import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thinkhub/generated/l10n.dart';
import 'package:thinkhub/src/application/core/process_state.dart';
import 'package:thinkhub/src/application/web_view/web_view_bloc.dart';
import 'package:thinkhub/src/presentation/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  static const route = "web_view";

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewArgument? arguments;

  WebViewBloc? _bloc;

  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    arguments ??= ModalRoute.of(context)?.settings.arguments as WebViewArgument;
    assert(arguments != null);

    if (_bloc == null) {
      _bloc = Provider.of<WebViewBloc>(context);
      _bloc!.title = arguments!.title;
      _bloc!.url = arguments!.url;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _bloc!.title.toUpperCase(),
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: AppColors.white,
              ),
        ),
      ),
      body: _getBodyLayout(),
    );
  }

  Widget _getBodyLayout() {
    return Stack(
      children: [
        WebView(
          onWebViewCreated: (controller) {
            _controller = controller;
          },
          initialUrl: _bloc!.url,
          onProgress: (value) {
            if (value < 100) {
              _bloc!.processState.add(ProcessState.busy());
            } else {
              _bloc!.processState.add(ProcessState.completed());
            }
          },
          navigationDelegate: (request) {
            if (request.url.contains("mailto:")) {
              launchUrl(Uri.parse(request.url));
              return NavigationDecision.prevent;
            }
            if (arguments!.successUrl != null ||
                arguments!.failureUrl != null) {
              if (request.url.startsWith(arguments!.successUrl ?? " ")) {
                Navigator.pop(context, request.url);
                return NavigationDecision.prevent;
              } else if (request.url.startsWith(arguments!.failureUrl ?? " ")) {
                Navigator.pop(context, null);
                return NavigationDecision.prevent;
              }
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            if (error.failingUrl != null &&
                !error.failingUrl!.startsWith(arguments!.successUrl ?? " ") &&
                !error.failingUrl!.startsWith(arguments!.failureUrl ?? " ")) {
              _bloc!.processState.add(ProcessState.error());
              debugPrint(error.toString());
            }
          },
          onPageStarted: (url) async {
            if (arguments!.isHeaderRequired && url != _bloc!.currentUrl) {
              _controller!.loadUrl(
                url,
                headers: _bloc!.headers,
              );
              _bloc!.currentUrl = url;
            }
            _bloc!.processState.add(ProcessState.busy());
          },
          onPageFinished: (url) {
            if ((arguments!.successUrl == null &&
                    arguments!.failureUrl == null) ||
                (!url.startsWith(arguments?.successUrl ?? " ") &&
                    !url.startsWith(arguments?.failureUrl ?? " "))) {
              _bloc!.processState.add(ProcessState.completed());
            }
          },
          javascriptMode: JavascriptMode.unrestricted,
          userAgent:
              "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36",
        ),
        StreamBuilder<ProcessState>(
          stream: _bloc!.processState,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == ProcessState.busy()) {
              return const ColoredBox(
                color: AppColors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasData &&
                snapshot.data == ProcessState.error()) {
              return ColoredBox(
                color: AppColors.white,
                child: Center(
                  child: Text(
                    S.current.errWebView,
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ],
    );
  }
}

class WebViewArgument {
  String title;
  String url;
  String? successUrl;
  String? failureUrl;
  bool isHeaderRequired;

  WebViewArgument({
    required this.title,
    required this.url,
    this.successUrl,
    this.failureUrl,
    this.isHeaderRequired = false,
  });
}
