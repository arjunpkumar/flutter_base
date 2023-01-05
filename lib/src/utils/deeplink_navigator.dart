import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinkhub/src/core/constants.dart';
import 'package:thinkhub/src/utils/share_preference_util.dart';

class DeeplinkNavigator {
  final SharedPreferences prefs;

  DeeplinkNavigator({required this.prefs});

  Future<void> handleDeepLink({
    required String type,
    String notifierId = '',
    bool isAppLaunch = false,
    dynamic data,
    Function(String)? onUnknownType,
  }) async {
    if (isAppLaunch) {
      await prefs.setString(SharedPrefKey.kDeepLinkType, type);
      await prefs.setString(SharedPrefKey.kNotifierId, notifierId);
      return;
    }
    switch (type) {
      case DeepLinkType.profile:
        break;
      default:
        if (onUnknownType != null) {
          onUnknownType(type);
        }
    }
  }

/*  Future<void> navigateToWebViewScreen(
    WebViewArgument data,
  ) async {
    await navigatorKey.currentState.pushNamed(
      WebViewPage.route,
      arguments: data,
    );
  }*/

}
