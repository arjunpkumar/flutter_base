import 'dart:async';

import 'package:flutter_base/config.dart';
import 'package:flutter_base/src/core/app.dart';

Future<void> main() async {
  Config.appFlavor = Staging();
  await initApp();
}
