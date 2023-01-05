import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinkhub/src/utils/deeplink_navigator.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static final LocalNotificationService _notificationService =
      LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  DeeplinkNavigator? _navigator;
  SharedPreferences? _prefs;

  factory LocalNotificationService() {
    return _notificationService;
  }

  LocalNotificationService._internal();

  static const channelID = "AHOYAPP";
  static const selfTemperatureAndroidNotificationID = 921;
  static const scheduleIDFor9AM = 9;
  static const scheduleIDFor9PM = 21;

  Future<void> init() async {
    if (Platform.isIOS || Platform.isAndroid) {
      await _configureLocalTimeZone();
    }

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      final payload =
          notificationAppLaunchDetails!.notificationResponse?.payload;
      selectNotification(payload);
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
      'local_notification_icon',
    );
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) =>
          selectNotification(response.payload),
    );

    if (Platform.isAndroid || Platform.isFuchsia) {
      _createNotificationChannel("fcm_default_channel", "Ahoy Default Channel");
    }
  }

  Future _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> _createNotificationChannel(String id, String name) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final androidNotificationChannel = AndroidNotificationChannel(
      id,
      name,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  Future selectNotification(String? payload) async {
    _prefs ??= await SharedPreferences.getInstance();
    _navigator ??= DeeplinkNavigator(prefs: _prefs!);

/*    if (payload == DeepLinkType.selfTemperatureLog) {
      _navigator.handleDeepLink(
        type: DeepLinkType.selfTemperatureLog,
        notifierId: "",
        isAppLaunch: navigatorKey.currentContext == null,
      );
    }*/
  }

  Future onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    _prefs ??= await SharedPreferences.getInstance();
    _navigator ??= DeeplinkNavigator(prefs: _prefs!);

/*    _navigator!.handleDeepLink(
      type: DeepLinkType.selfTemperatureLog,
      notifierId: "",
      isAppLaunch: navigatorKey.currentContext == null,
    );*/
  }

/*
  Future scheduleSelfTemperatureNotification() async {
    await _scheduleDailyNotification(
      scheduleIDFor9AM,
      id: scheduleIDFor9AM,
      title: "selfTemperatureNotificationTitle".tr(),
      body: "selfTemperatureNotificationBody".tr(),
      payload: DeepLinkType.selfTemperatureLog,
    );
    await _scheduleDailyNotification(
      scheduleIDFor9PM,
      id: scheduleIDFor9PM,
      title: "selfTemperatureNotificationTitle".tr(),
      body: "selfTemperatureNotificationBody".tr(),
      payload: DeepLinkType.selfTemperatureLog,
    );
  }
*/

  /*Future<void> _scheduleDailyNotification(
    int hourIn24HoursFormat, {
    int id,
    String title = 'AHOY',
    String body = '',
    String payload,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _scheduleDaily(hourIn24HoursFormat),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          channelID,
          "Ahoy",
          priority: Priority.high,
          importance: Importance.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }*/

  tz.TZDateTime _scheduleDaily(int hourIn24HoursFormat) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hourIn24HoursFormat,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future cancelSelfTemperatureLogNotification() async {
    await flutterLocalNotificationsPlugin.cancel(scheduleIDFor9AM);
    await flutterLocalNotificationsPlugin.cancel(scheduleIDFor9PM);
  }

  Future cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  void setNavigator(DeeplinkNavigator navigator) {
    _navigator = navigator;
  }
}
