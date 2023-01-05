import 'dart:async';

import 'package:dio/dio.dart';
import 'package:thinkhub/src/domain/core/repository_provider.dart';

class NetworkAuthInterceptor extends InterceptorsWrapper {
  static final _singleton = NetworkAuthInterceptor._internal();

  factory NetworkAuthInterceptor() => _singleton;

  NetworkAuthInterceptor._internal();

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await provideAuthRepository().processAuthError();
    }
    super.onError(err, handler);
  }
}
