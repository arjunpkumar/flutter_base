import 'package:flutter_base/src/application/core/base_bloc.dart';
import 'package:flutter_base/src/application/web_view/web_view_event.dart';
import 'package:flutter_base/src/application/web_view/web_view_state.dart';
import 'package:flutter_base/src/domain/auth/auth_repository.dart';
import 'package:flutter_base/src/utils/network_utils.dart';

class WebViewBloc extends BaseBloc<WebViewEvent, WebViewState> {
  final AuthRepository authRepository;
  final bool isHeaderRequired;
  final bool isBackConfirmationRequired;
  final String url;
  final String title;
  final String? successUrl;
  final String? alternateSuccessUrl;
  final String? failureUrl;

  String? currentUrl;
  Map<String, String>? headers;
  bool isPageLoading = false;

  WebViewBloc({
    required this.authRepository,
    required this.isHeaderRequired,
    required this.url,
    required this.title,
    this.successUrl,
    this.alternateSuccessUrl,
    this.failureUrl,
    this.isBackConfirmationRequired = false,
  }) : super(WebViewState()) {
    if (isHeaderRequired) {
      setHeader();
    }

    on<WebViewEvent>((event, emit) {
      emit(state.copyWith()..processState = event.processState);
    });
  }

  Future<void> setHeader() async {
    final map = await getHeader();
    headers = map.map((key, value) => MapEntry(key, value.toString()));
  }

  Future<Map<String, dynamic>> getHeader() async {
    final authToken = await authRepository.getActiveToken();
    return getHeaders(authToken);
  }
}
