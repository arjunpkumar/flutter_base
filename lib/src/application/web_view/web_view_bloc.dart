import 'package:thinkhub/src/application/core/base_bloc.dart';
import 'package:thinkhub/src/application/web_view/web_view_event.dart';
import 'package:thinkhub/src/application/web_view/web_view_state.dart';
import 'package:thinkhub/src/domain/auth/auth_repository.dart';
import 'package:thinkhub/src/utils/network_utils.dart';

class WebViewBloc extends BaseBloc<WebViewEvent, WebViewState> {
  late String title;
  late String url;
  String? currentUrl;
  Map<String, String>? headers;
  final AuthRepository authRepository;
  final bool isHeaderRequired;

  WebViewBloc({
    required this.authRepository,
    required this.isHeaderRequired,
  }) : super(WebViewState()) {
    if (isHeaderRequired) {
      setHeader();
    }
  }

  Future<void> setHeader() async {
    final map = await getHeader();
    headers = map.map((key, value) => MapEntry(key, value.toString()));
  }

  Future<Map<String, dynamic>> getHeader() async {
    final authToken = await authRepository.getActiveSessionToken();
    return getHeaders(authToken);
  }
}
