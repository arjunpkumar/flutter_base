import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:thinkhub/src/core/constants.dart';

bool notNull(dynamic source) {
  return source != null;
}

String extractName(String firstName, String lastName) {
  return [firstName, lastName].where(notNull).join(" ");
}

String getInitials(List<String>? inputs) {
  if (inputs == null || inputs.isEmpty) {
    return '';
  }

  return inputs
      .where(notNull)
      .map((i) => i.trim())
      .where((i) => i.isNotEmpty)
      .map((s) => s.substring(0, 1))
      .join()
      .toUpperCase();
}

class IndexWalker {
  dynamic value;

  IndexWalker(this.value);

  IndexWalker operator [](Object index) {
    if (value != null) {
      value = toGenericMap(value)![index];
    }
    return this;
  }
}

/// [inputFromDate]newly selected from date
/// [inputToDate]newly selected to date
/// [pastFromDate]already exited from date
/// [pastToDate]already existed to date
bool isDatesInRange({
  required DateTime inputFromDate,
  required DateTime inputToDate,
  required DateTime pastFromDate,
  required DateTime pastToDate,
}) {
  //for checking the input date is not in range with past dates
  final isInputFromDateInRange = isDateInRange(
    testDate: inputFromDate,
    fromDate: pastFromDate,
    toDate: pastToDate,
  );
  final isInputToDateInRange = isDateInRange(
    testDate: inputToDate,
    fromDate: pastFromDate,
    toDate: pastToDate,
  );

  //for checking the past date is not in range with input dates
  final isPastFromDateInRange = isDateInRange(
    testDate: pastFromDate,
    fromDate: inputFromDate,
    toDate: inputToDate,
  );
  final isPastToDateInRange = isDateInRange(
    testDate: pastToDate,
    fromDate: inputFromDate,
    toDate: inputToDate,
  );

  return isInputFromDateInRange ||
      isInputToDateInRange ||
      isPastFromDateInRange ||
      isPastToDateInRange;
}

bool isDateInRange({
  required DateTime testDate,
  required DateTime fromDate,
  required DateTime toDate,
}) {
  return isDateEqualsAfter(testDate, fromDate) &&
      isDateEqualsBefore(testDate, toDate);
}

bool isDateEqualsAfter(DateTime toCheck, DateTime forCheck) {
  return toCheck == forCheck || toCheck.isAfter(forCheck);
}

bool isDateEqualsBefore(DateTime toCheck, DateTime forCheck) {
  return toCheck == forCheck || toCheck.isBefore(forCheck);
}

DateTime? maxDate(List<DateTime>? dates) {
  if (dates == null || dates.isEmpty) {
    return null;
  }
  return dates.reduce((curr, next) => next.isAfter(curr) ? next : curr);
}

int dataLengthInBytes(dynamic data) {
  int bytes;
  if (data != null) {
    bytes = utf8.encode(data.toString()).length;
  } else {
    bytes = 0;
  }
  return bytes;
}

String formatBytes(double? bytes, {int precision = 2}) {
  if (bytes == null || bytes <= 0) {
    return "0 B";
  }

  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  final i = (math.log(bytes) / math.log(1024)).floor();
  final val = (bytes / math.pow(1024, i)).toStringAsFixed(precision);
  return '$val ${suffixes[i]}';
}

String? normalizeDate(String? dateString) {
  if (dateString != null) {
    return dateString.contains("T")
        ? dateString.contains("Z")
            ? dateString
            : "${dateString}Z"
        : "${dateString}T00:00:00Z";
  }
  return null;
}

String? formatDate(DateTime? dateTime, {String format = 'dd/MM/yyyy'}) {
  if (dateTime == null) {
    return null;
  }
  return DateFormat(format).format(dateTime.toLocal());
}

String? getTimeFormat(DateTime? dateTime, BuildContext context) {
  if (dateTime == null) {
    return null;
  }
  return TimeOfDay.fromDateTime(dateTime).format(context);
}

String? durationInDaysHoursMinutes(DateTime? fromTime, DateTime? toTime) {
  if (fromTime == null || toTime == null) {
    return null;
  }
  final duration = toTime.difference(fromTime);
  return [
    if (duration.inDays > 0) "${duration.inDays}d",
    if (duration.inHours.remainder(24) > 0)
      "${duration.inHours.remainder(24)}h",
    if (duration.inMinutes.remainder(60) > 0)
      "${duration.inMinutes.remainder(60)}min",
  ].join(" ");
}

Future<String> absolutePath(String relativePath) async {
  final dir = await getApplicationDocumentsDirectory();
  return p.joinAll([dir.path, relativePath]);
}

Future<void> createDir(String basePath) async {
  final path = await absolutePath(basePath);
  final dir = Directory(path);
  final exists = await dir.exists();
  if (!exists) {
    await dir.create(recursive: true);
  }
}

DateTime today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

Future<bool> isDeviceIOSSimulator() async {
  bool isSimulator = false;
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    final info = await DeviceInfoPlugin().iosInfo;
    isSimulator = !info.isPhysicalDevice;
  }
  return isSimulator;
}

Future<String> getOSType() async {
  if (kIsWeb) return "Web";

  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
      return "iOS";
    case TargetPlatform.android:
      return "Android";
    case TargetPlatform.fuchsia:
      return "Fuchsia";
    case TargetPlatform.linux:
      return "Linux";
    case TargetPlatform.macOS:
      return "MacOS";
    case TargetPlatform.windows:
      return "Windows";
    default:
      return "Other";
  }
}

String encodeToBase64(String string) {
  final bytes = utf8.encode(string);
  return base64.encode(bytes);
}

extension StringFormatting on String {
  String toCapitalized() {
    switch (length) {
      case 0:
        return this;
      case 1:
        return this[0].toUpperCase();
      default:
        return this[0].toUpperCase() + substring(1);
    }
  }

  String toPascalCase() {
    return split(" ")
        .map((word) => word.toCapitalized())
        .join(" ")
        .split("/")
        .map((word) => word.toCapitalized())
        .join("/");
  }

  double toDouble() {
    return double.tryParse(this) ?? 0.0;
  }

  int toInt() {
    return int.tryParse(this) ?? 0;
  }
}

Map<String, dynamic>? toGenericMap(dynamic map) {
  if (map == null) return null;
  return Map<String, dynamic>.from(map);
}

List? toGenericList(dynamic list) {
  if (list == null) return null;
  return List.from(list);
}

List<Map<String, dynamic>>? toGenericMapList(dynamic list) {
  if (list == null && list is! List) return null;
  return List<Map<String, dynamic>>.from(
    toGenericList(list)!.map((e) => toGenericMap(e)).toList(),
  );
}

extension AmountFormat on double {
  String toInternationalNumberFormatStringAsFixed({
    String format = "#,###.00",
    int decimalDigits = 2,
  }) {
    return formatNumber(this, format, decimalDigits);
  }
}

extension DateTimeUtils on DateTime {
  String? get iso8601DateString => formatDate(this, format: 'yyyy-MM-dd');

  String? get dateStringDDMMMYYYY => formatDate(this, format: 'dd MMM yyyy');

  DateTime removeTime({bool toUtc = false}) =>
      toUtc ? DateTime.utc(year, month, day) : DateTime(year, month, day);

  bool isSameDate(DateTime other) =>
      removeTime().difference(other.removeTime()) == Duration.zero;

  int differenceInMonths(DateTime other) {
    if (isAfter(other)) {
      if (year > other.year) {
        if (day >= other.day) {
          return (12 + month) - other.month;
        } else {
          return (12 + month - 1) - other.month;
        }
      } else {
        if (day >= other.day) {
          return month - other.month;
        } else {
          return month - 1 - other.month;
        }
      }
    } else {
      return 0;
    }
  }
}

extension ListUtil on List {
  bool containsAny<T>(List<T> list) {
    for (final T element in this as List<T>) {
      if (list.contains(element)) return true;
    }
    return false;
  }

  bool isSame<T>(List<T> list) {
    if ((this as List<T>).length != list.length) return false;
    for (final T element in this as List<T>) {
      if (!list.contains(element)) return false;
    }
    return true;
  }
}

void hideKeyboard(BuildContext context) {
  final FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

/*String convertDaysToMonthsAndDays(
  int dayCount,
  DateTime startDate,
  DateTime endDate,
) {
  if (dayCount == null || startDate == null || endDate == null) return null;
  int months;
  int days;
  final newStartDate = startDate.add(const Duration(days: -1));
  months = endDate.differenceInMonths(newStartDate);
  if (months > 0) {
    final tempDate = DateTime(
      newStartDate.year,
      newStartDate.month + months,
      newStartDate.day,
    );
    days = endDate.difference(tempDate).inDays;
    final String strMonth =
        "labelXMonth".plural(months, args: [months.toString()]);
    final String strDay = "labelXDay".plural(days, args: [days.toString()]);

    return days > 0 ? "$strMonth ${"andText".tr()} $strDay" : strMonth;
  } else {
    days = endDate.difference(newStartDate).inDays;
    return "labelXDay".plural(days, args: [days.toString()]);
  }
}*/

String formatNumber(double value, String format, int decimelValue) {
  final formatter = NumberFormat(format, 'en_us');
  final fixedAmountString = value.toStringAsFixed(decimelValue);
  if (value >= 1 || value <= -1) {
    return formatter.format(fixedAmountString.toDouble());
  }
  return fixedAmountString;
}

///converts bytes to KBs or MBs or GBs
extension SizeUnitsConversion on int {
  String convertSizeUnits() {
    if (this > gbInBytes) {
      return "${(this / gbInBytes).toInternationalNumberFormatStringAsFixed()} GB";
    } else if (this > mbInBytes) {
      return "${(this / mbInBytes).toInternationalNumberFormatStringAsFixed()} MB";
    } else if (this > kbInBytes) {
      return "${(this / kbInBytes).toInternationalNumberFormatStringAsFixed()} KB";
    } else {
      return "$this Bytes";
    }
  }
}
