import 'package:flutter/foundation.dart';
import 'package:thinkhub/src/domain/auth/user_repository.dart';
import 'package:thinkhub/src/domain/core/log_services.dart';
import 'package:thinkhub/src/domain/fcm/device_token_repository.dart';
import 'package:thinkhub/src/utils/extensions.dart';

class DeviceTokenHelper {
  final DeviceTokenRepository deviceTokenRepository;
  final UserRepository userRepository;

  DeviceTokenHelper({
    required this.deviceTokenRepository,
    required this.userRepository,
  });

  Future<void> registerToken() async {
    final user = await userRepository.getActiveUser();
    try {
      final isSimulator = await isDeviceIOSSimulator();
      if (!isSimulator) {
        await deviceTokenRepository.registerToken(userID: user!.id);
        Logger().log(LogEvents.deviceRegistration, null);
      }
    } catch (err) {
      debugPrint(err.toString());
      Logger().log(LogEvents.deviceRegistrationFailed, null);
    }
  }
}
