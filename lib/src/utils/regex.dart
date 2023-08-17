import 'package:flutter/services.dart';

String pattern = r'(^\d*\.?\d*)';
RegExp regExp = RegExp(pattern);

List<TextInputFormatter> validateDoubleDecimalNumber() {
  return [
    FilteringTextInputFormatter.allow(regExp),
  ];
}
