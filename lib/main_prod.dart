import 'dart:async';

import 'package:thinkhub/config.dart';
import 'package:thinkhub/src/core/app.dart';

Future<void> main() async {
  Config.appFlavor = Production();
  await initApp();
}
