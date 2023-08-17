import 'package:dio/dio.dart';
import 'package:flutter_base/config.dart';
import 'package:flutter_base/src/domain/auth/auth_repository.dart';
import 'package:flutter_base/src/domain/database/core/app_database.dart';

Future<Options> getDioOptions({required AuthRepository authRepository}) async {
  final activeSessionToken = await authRepository.getActiveToken();
  return Options(
    headers: getHeaders(activeSessionToken),
  );
}

Map<String, dynamic> getHeaders(AuthToken? activeSessionToken) {
  return {
    if (activeSessionToken != null)
      'Authorization': 'Bearer ${activeSessionToken.accessToken}',
    'app': 'FlutterBase',
    'version': Config.getVersionName(),
    'build': Config.getBuildNumber(),
    'source': Config.appSource,
    'Content-Type': 'application/json',
  };
}

class AppSource {
  AppSource._();

  static const String web = 'WEB';
  static const String windows = 'WINDOWS';
  static const String macOS = 'MACOS';
  static const String linux = 'LINUX';
  static const String android = 'MOBILE_ANDROID';
  static const String iOS = 'MOBILE_IOS';
}
