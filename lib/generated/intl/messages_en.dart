// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(username, status) => "${username} is ${status}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "_locale": MessageLookupByLibrary.simpleMessage("en"),
        "btnCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "btnLater": MessageLookupByLibrary.simpleMessage("Later"),
        "btnUpdate": MessageLookupByLibrary.simpleMessage("Update"),
        "btnView": MessageLookupByLibrary.simpleMessage("View"),
        "errWebView": MessageLookupByLibrary.simpleMessage(
            "Error Loading The Web Page. Try Again Later"),
        "messageFlexibleUpdate": MessageLookupByLibrary.simpleMessage(
            "There is a new version available for this app. Try out new features by updating the app."),
        "messageImmediateUpdate": MessageLookupByLibrary.simpleMessage(
            "Kindly update this app to the latest version to improve its compatibility."),
        "messagePleaseAuthenticateUsingBiometric":
            MessageLookupByLibrary.simpleMessage(
                "Please Authenticate Using Biometric or Device Lock Mechanism"),
        "titleFlexibleUpdate":
            MessageLookupByLibrary.simpleMessage("Update Available"),
        "titleImmediateUpdate":
            MessageLookupByLibrary.simpleMessage("Update Required"),
        "userStatus": m0
      };
}
