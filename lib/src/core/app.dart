import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinkhub/config.dart';
import 'package:thinkhub/generated/l10n.dart';
import 'package:thinkhub/src/application/core/bloc_provider.dart';
import 'package:thinkhub/src/core/constants.dart';
import 'package:thinkhub/src/core/routes.dart';
import 'package:thinkhub/src/domain/core/config_repository.dart';
import 'package:thinkhub/src/domain/core/log_services.dart';
import 'package:thinkhub/src/domain/core/repository_provider.dart';
import 'package:thinkhub/src/presentation/core/theme/text_styles.dart';
import 'package:thinkhub/src/presentation/widgets/app_version_widget.dart';
import 'package:thinkhub/src/utils/deeplink_handler.dart';
import 'package:thinkhub/src/utils/deeplink_navigator.dart';
import 'package:thinkhub/src/utils/error_logger.dart';
import 'package:thinkhub/src/utils/notifications_handler.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseRemoteConfig.instance.ensureInitialized();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  final shouldEnablePerformanceMonitoring =
      Config.appFlavor is Production && Config.appMode == AppMode.release;

  final documentsDirectory = await getApplicationDocumentsDirectory();
  Hive.init(documentsDirectory.path);

  // Disable DebugPrint in Release Mode
  if (Config.appMode == AppMode.release) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  if (!kIsWeb &&
      (Platform.isAndroid ||
          Platform.isFuchsia ||
          Platform.isIOS ||
          Platform.isMacOS)) {
    Config.packageInfo = await PackageInfo.fromPlatform();
  }

// Sync Configs
  try {
    final configsRepository = ConfigRepository.instance;
    await configsRepository.initConfig();
    await configsRepository.syncConfig();
  } catch (e) {
    rethrow;
  }

/*  if(Config.appFlavor is! Production && Config.appMode != AppMode.release){
    final driver = StorageServerDriver(
        bundleId: Config.packageInfo.packageName, //Used for identification
        port: 0, //Default 0, use 0 to automatically use a free port
    );
    driver.addSQLServer(SQLDatabaseServer);
  }*/

  runZonedGuarded<Future<void>>(
    () async {
      runApp(App());
    },
    (error, stackTrace) {
      if (Config.appMode == AppMode.release) {
        ErrorLogger().recordError(
          exception: error,
          stackTrace: stackTrace,
        );
      }
    },
  );
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  late DeeplinkHandler _deeplinkHandler;
  late NotificationsHandler _notificationsHandler;

  @override
  void initState() {
    super.initState();

    _setupHandlers();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // removeBadge();
        break;
      default:
        break;
    }

    super.didChangeAppLifecycleState(state);
  }

  Future<void> removeBadge() async {
    try {
      final status = await Permission.notification.status;
      if (status.isDenied) {
        return;
      }
      // FlutterAppBadger.removeBadge();
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      builder: (context, child) => Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => AppVersionWidget(
              configsRepository: ConfigRepository.instance,
              child: child!,
            ),
          );
        },
      ),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      navigatorObservers: [
        FirebaseAnalyticsObserver(
          analytics: FirebaseAnalytics.instance,
          nameExtractor: (settings) => screenName(settings.name ?? "Other"),
        ),
      ],
      theme: ThemeData(
        textTheme: TextTheme(
          headline1: TextStyles.h1ExtraLight(context),
          headline2: TextStyles.h2ExtraLight(context),
          headline3: TextStyles.h2Light(context),
          headline4: TextStyles.titleSemiBold(context),
          headline6: TextStyles.title2Bold(context),
          subtitle2: TextStyles.title3Bold(context),
          subtitle1: TextStyles.title2Medium(context),
          bodyText2: TextStyles.body1Regular(context),
          bodyText1: TextStyles.body1Bold(context),
          caption: TextStyles.captionRegular(context),
          overline: TextStyles.captionBold(context),
          button: TextStyles.buttonBlack(context),
        ),
        dialogTheme: DialogTheme(
          titleTextStyle: Theme.of(context).textTheme.headline6,
          contentTextStyle: Theme.of(context).textTheme.bodyText2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Units.kCardBorderRadius),
          ),
        ),
        cardTheme: CardTheme(
          elevation: Units.kCardElevation,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Units.kCardBorderRadius),
          ),
        ),
      ),
      routes: routes,
      onGenerateRoute: (settings) => generatedRoutes(settings),
    );
  }

  Future<void> _setupHandlers() async {
    final prefs = await SharedPreferences.getInstance();
    final navigator = DeeplinkNavigator(prefs: prefs);

    // Configure Push Notifications
    final messagingService = provideFireBaseMessaging();

    _notificationsHandler = NotificationsHandler(
      messagingService: messagingService,
      authRepository: provideAuthRepository(),
      userRepository: provideUserRepository(),
      navigator: navigator,
      notificationUtil: provideNotificationUtil(),
    );
    _notificationsHandler.setup();
    // Configure Deep Link
    _deeplinkHandler = DeeplinkHandler(navigator: navigator);
    await _deeplinkHandler.setup();
    // LocalNotificationService().setNavigator(navigator);
  }
}
