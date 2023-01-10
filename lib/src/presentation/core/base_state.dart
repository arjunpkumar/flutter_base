import 'package:flutter/material.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  fieldFocusChange(
    BuildContext context,
    FocusNode currentFocus,
    FocusNode nextFocus,
  ) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  showSnackBar(String message, Duration time, SnackBarAction? action) {
    SnackBar snackBar;
    if (action == null) {
      snackBar = SnackBar(
        content: Text(message),
        duration: time,
      );
    } else {
      snackBar = SnackBar(
        content: Text(message),
        action: action,
        duration: time,
      );
    }

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
