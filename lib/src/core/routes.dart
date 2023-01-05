import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thinkhub/src/application/core/bloc_provider.dart';
import 'package:thinkhub/src/application/web_view/web_view_bloc.dart';
import 'package:thinkhub/src/presentation/web_view/web_view_page.dart';

final Map<String, Widget Function(BuildContext context)> routes = {
/*  SplashPage.route: (_) => Provider<SplashBloc>(
        create: (_) => provideSplashBloc(),
        dispose: (_, bloc) => bloc.dispose(),
        child: SplashPage(),
      ),
  HomePage.route: (_) => Provider<HomeBloc>(
        create: (_) => provideHomeBloc(),
        dispose: (_, bloc) => bloc.dispose(),
        child: HomePage(),
      ),*/
};

Route<dynamic>? generatedRoutes(RouteSettings settings) {
  final uri = Uri.parse(settings.name ?? '');
  debugPrint("URI.PATH : ${uri.path}");
  debugPrint("URI.queryParams : ${uri.queryParameters}");
  debugPrint("Settings : ${settings.name}");
  debugPrint("Arguments :  ${settings.arguments ?? "null"}");

  switch (uri.path) {
    case WebViewPage.route:
      if (settings.arguments != null && settings.arguments is WebViewArgument) {
        return _getWebViewRoute(
          settings,
          settings.arguments as WebViewArgument,
        );
      }
      break;
  }
  return null;
}

MaterialPageRoute _getWebViewRoute(
  RouteSettings settings,
  WebViewArgument argument,
) {
  return MaterialPageRoute(
    builder: (context) => Provider<WebViewBloc>(
      create: (context) => provideWebViewBloc(argument.isHeaderRequired),
      dispose: (_, bloc) => bloc.dispose(),
      child: WebViewPage(),
    ),
    settings: settings,
  );
}
