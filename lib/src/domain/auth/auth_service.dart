import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:thinkhub/config.dart';
import 'package:thinkhub/src/core/app.dart';
import 'package:thinkhub/src/core/constants.dart';
import 'package:thinkhub/src/domain/database/core/app_database.dart';
import 'package:thinkhub/src/presentation/web_view/web_view_page.dart';

class AuthService {
  final _clientId = 'SynergyMobile';
  final List<String> _scopes = [
    'openid',
    'profile',
    'thinkhubapi',
    'email',
    'offline_access',
  ];

  Future<oauth2.Credentials?> signIn({required String codeVerifier}) {
    final grant = _getAuthorisationCodeGrant(codeVerifier);

    final Uri authorizationUrl = _getAuthorizationUrl(grant);

    return _openAuthorizationServerLogin(
      "titleLogin",
      authorizationUrl,
      codeVerifier,
    );
  }

  Uri _getAuthorizationUrl(oauth2.AuthorizationCodeGrant grant) {
    final authorizationUrl = grant.getAuthorizationUrl(
      Uri.parse(Config.appFlavor.authRedirectUri),
      scopes: _scopes,
    );
    return authorizationUrl;
  }

  oauth2.AuthorizationCodeGrant _getAuthorisationCodeGrant(
    String codeVerifier, {
    String? authUrl,
    String? authTokenUrl,
  }) {
    final grant = oauth2.AuthorizationCodeGrant(
      _clientId,
      Uri.parse(authUrl ?? APIEndpoints.authUrl),
      Uri.parse(authTokenUrl ?? APIEndpoints.authTokenUrl),
      httpClient: http.Client(),
      codeVerifier: codeVerifier,
    );
    return grant;
  }

  Future<oauth2.Credentials?> _openAuthorizationServerLogin(
    String title,
    Uri authorizationUrl,
    String codeVerifier, {
    bool isAuthTokenNeeded = true,
    String? failureUrl,
  }) async {
    final result = await navigatorKey.currentState?.pushNamed(
      WebViewPage.route,
      arguments: WebViewArgument(
        title: title,
        url: authorizationUrl.toString(),
        successUrl: Config.appFlavor.authRedirectUri,
        failureUrl: failureUrl,
      ),
    );

    if (isAuthTokenNeeded && result != null) {
      return handleOAuthRedirectWeb(Uri.parse(result.toString()), codeVerifier);
    }
    return null;
  }

  Future<oauth2.Credentials> handleOAuthRedirectWeb(
    Uri redirectUri,
    String codeVerifier,
  ) async {
    final oauth2.AuthorizationCodeGrant grant =
        _getAuthorisationCodeGrant(codeVerifier);
    _getAuthorizationUrl(grant);
    try {
      final client =
          await grant.handleAuthorizationResponse(redirectUri.queryParameters);
      return client.credentials;
    } catch (e) {
      rethrow;
    }
  }

  Future<oauth2.Credentials> refreshAccessToken(
    oauth2.Credentials credentials,
  ) async {
    var client = oauth2.Client(credentials, identifier: _clientId);
    client = await client.refreshCredentials(_scopes);
    return client.credentials;
  }

  Future<void> signOut(AuthToken token, String codeVerifier) async {
    final url = '${APIEndpoints.logoutUrl}?id_token_hint=${token.idToken}'
        '&post_logout_redirect_uri=${Config.appFlavor.authRedirectUri}';
    final grant = _getAuthorisationCodeGrant(
      codeVerifier,
      authUrl: url,
      authTokenUrl: url,
    );

    final Uri authorizationUrl = _getAuthorizationUrl(grant);

    await _openAuthorizationServerLogin(
      "titleLogout",
      authorizationUrl,
      codeVerifier,
      failureUrl: APIEndpoints.loginUrl,
      isAuthTokenNeeded: false,
    );
  }
}
