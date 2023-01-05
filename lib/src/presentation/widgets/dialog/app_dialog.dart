import 'package:flutter/material.dart';

///Returns true if Positive Button clicked, false otherwise
Future<bool?> openAppDialog(
  BuildContext context, {
  String? title,
  String? content,
  Widget? child,
  String? positiveButtonText,
  String? negativeButtonText,
}) {
  assert(title != null || child != null);
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, false);
          return true;
        },
        child: AlertDialog(
          title: title != null
              ? Text(
                  title,
                  style: Theme.of(context).textTheme.headline6,
                )
              : null,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (content != null)
                Text(
                  content,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              if (child != null) child
            ],
          ),
          actions: <Widget>[
            if (negativeButtonText != null)
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(negativeButtonText.toUpperCase()),
              ),
            if (positiveButtonText != null)
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(positiveButtonText.toUpperCase()),
              ),
          ],
        ),
      );
    },
  );
}
