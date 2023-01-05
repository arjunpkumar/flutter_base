import 'package:dio/dio.dart';
import 'package:thinkhub/config.dart';
import 'package:thinkhub/src/domain/auth/auth_repository.dart';
import 'package:thinkhub/src/domain/database/core/app_database.dart';

Future<Options> getDioOptions({required AuthRepository authRepository}) async {
  final activeSessionToken = await authRepository.getActiveSessionToken();
  return Options(
    headers: getHeaders(activeSessionToken),
  );
}

Map<String, dynamic> getHeaders(AuthToken? activeSessionToken) {
  return {
    if (activeSessionToken != null)
      'Authorization': 'Bearer ${activeSessionToken.accessToken}',
    'app': 'Ahoy',
    'version': Config.getVersionName(),
  };
}
