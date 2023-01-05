import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:synchronized/synchronized.dart';
import 'package:thinkhub/src/core/app.dart';
import 'package:thinkhub/src/core/exceptions.dart';
import 'package:thinkhub/src/domain/auth/auth_service.dart';
import 'package:thinkhub/src/domain/auth/user_repository.dart';
import 'package:thinkhub/src/domain/core/log_services.dart';
import 'package:thinkhub/src/domain/database/auth_settings_dao.dart';
import 'package:thinkhub/src/domain/database/auth_token_dao.dart';
import 'package:thinkhub/src/domain/database/core/app_database.dart';
import 'package:thinkhub/src/presentation/widgets/loader_widget.dart';
import 'package:thinkhub/src/utils/secure_storage_util.dart';

class AuthRepository {
  static AuthRepository? instance;

  final AuthService authServices;
  final AuthTokenDao authTokenDao;
  final AuthSettingsDao authSettingsDao;
  final UserRepository userRepository;
  final FlutterSecureStorage storage;
  final AppDatabase appDatabase;
  final Logger logger;

  static Lock? _lock;
  static const String _charset =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';

  AuthRepository({
    required this.authServices,
    required this.authTokenDao,
    required this.authSettingsDao,
    required this.appDatabase,
    required this.userRepository,
    required this.storage,
    required this.logger,
  }) {
    _lock ??= Lock();
  }

  static String _createCodeVerifier() {
    return List.generate(
      128,
      (i) => _charset[Random.secure().nextInt(_charset.length)],
    ).join();
  }

  Future<User?> signIn() async {
    await authTokenDao.deleteTokens();

    String? codeVerifier;
    if (await storage.containsKey(key: SecureStorageKey.codeVerifier)) {
      codeVerifier = await storage.read(key: SecureStorageKey.codeVerifier);
    }
    codeVerifier ??= _createCodeVerifier();
    _saveCodeVerifier(codeVerifier);

    final credentials = await authServices.signIn(codeVerifier: codeVerifier);
    if (credentials != null) {
      logger.log(LogEvents.loggedIn, null);
      _saveCredentials(credentials);
      return _updateUser(_generateAuthTokenFromCredential(credentials));
    } else {
      logger.log(LogEvents.logInFailed, null);
      return null;
    }
  }

  Future<void> _refreshAccessToken() async {
    final savedCredentials = oauth2.Credentials.fromJson(
      (await storage.read(key: SecureStorageKey.oAuthCredentials) ?? ''),
    );

    final credentials = await authServices.refreshAccessToken(savedCredentials);
    if (credentials != null) {
      _saveCredentials(credentials);
      await _updateUser(_generateAuthTokenFromCredential(credentials));
    }
  }

  AuthToken _generateAuthTokenFromCredential(oauth2.Credentials credential) {
    final authToken = AuthToken(
      accessToken: credential.accessToken,
      idToken: credential.idToken ?? '',
      refreshToken: credential.refreshToken ?? '',
    );
    return authToken;
  }

  Future<User> _updateUser(AuthToken authToken) async {
    final user = await userRepository.getUser(authToken.accessToken);
    logger.log(LogEvents.userFetchFromIDS, null);
    try {
      await userRepository.deleteUsers();
      await authTokenDao.deleteTokens();
      await authTokenDao.saveAuthToken(authToken);
      await userRepository.saveUser(user);
      logger.log(LogEvents.logInDBUpdate, null);
    } catch (e) {
      debugPrint(e.toString());
      logger.log(LogEvents.logInDBUpdateFailed, null);
      rethrow;
    }

    return user;
  }

  Future<AuthToken?> getActiveSessionToken() {
    return authTokenDao.getActiveSessionToken();
  }

  Future<bool> isSessionActive() async {
    final token = await getActiveSessionToken();
    final user = await userRepository.getActiveUser();
    return token != null && user != null;
  }

  Future<void> signOut() async {
    final token = await getActiveSessionToken();
    await storage.deleteAll();
    await appDatabase.clearUserRelatedTables();

    final String? codeVerifier =
        await storage.read(key: SecureStorageKey.codeVerifier);
    // await authServices.signOut(token, codeVerifier);
    await _saveCredentials(null);
  }

  Future<void> processAuthError() async {
    await _lock!.synchronized(() async {
      final lastRefresh = await authSettingsDao.getLastTokenRefresh();
      if (lastRefresh == null ||
          DateTime.now().toUtc().difference(lastRefresh).inMinutes >= 4) {
        await initRefreshAccessToken();
      }
    });
  }

  Future<void> initRefreshAccessToken() async {
    final token = await getActiveSessionToken();
    if (token?.refreshToken != null) {
      try {
        await _refreshAccessToken();
        // await authSettingsDao.saveLastTokenRefresh(DateTime.now().toUtc());
      } catch (err) {
        if ((err is PlatformException &&
                (err.code == "token_failed" ||
                    err.code == "401" ||
                    err.code == "400")) ||
            (err is oauth2.AuthorizationException &&
                err.error == "invalid_grant")) {
          await _logoutAndNavigateToLogin();
        }
        throw CustomException(
          "FAILED TO REFRESH TOKEN",
          message: err.toString(),
        );
      }
    } else {
      await _logoutAndNavigateToLogin();
    }
  }

  Future _logoutAndNavigateToLogin() async {
    showDialog(
      context: navigatorKey.currentState!.overlay!.context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const LoaderWidget(),
        );
      },
    );
    await signOut();
    Navigator.of(navigatorKey.currentState!.overlay!.context,
            rootNavigator: true)
        .pop();
/*    await navigatorKey.currentState.pushNamedAndRemoveUntil(
      SignInPage.route,
      ModalRoute.withName(HomePage.route),
    );*/
  }

  Future<void> _saveCodeVerifier(String codeVerifier) async {
    await storage.write(
      key: SecureStorageKey.codeVerifier,
      value: codeVerifier,
    );
  }

  Future<void> _saveCredentials(oauth2.Credentials? credentials) async {
    await storage.write(
      key: SecureStorageKey.oAuthCredentials,
      value: credentials?.toJson(),
    );
  }
}
