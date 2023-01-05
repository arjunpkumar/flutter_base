import 'package:thinkhub/src/application/splash/splash_bloc.dart';
import 'package:thinkhub/src/application/web_view/web_view_bloc.dart';
import 'package:thinkhub/src/domain/core/repository_provider.dart';
import 'package:thinkhub/src/utils/device_token_helper.dart';
import 'package:thinkhub/src/utils/notification_util.dart';

SplashBloc provideSplashPageBLoC() {
  return SplashBloc();
}

WebViewBloc provideWebViewBloc(bool isHeaderRequired) {
  return WebViewBloc(
    authRepository: provideAuthRepository(),
    isHeaderRequired: isHeaderRequired,
  );
}

DeviceTokenHelper provideDeviceTokenHelper() {
  return DeviceTokenHelper(
    deviceTokenRepository: provideDeviceTokenRepository(),
    userRepository: provideUserRepository(),
  );
}

NotificationUtil provideNotificationUtil() {
  return NotificationUtil(
    networkValidator: provideNetworkValidator(),
  );
}
