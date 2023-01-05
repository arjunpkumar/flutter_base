import 'package:thinkhub/src/application/core/base_bloc.dart';
import 'package:thinkhub/src/application/splash/splash_event.dart';
import 'package:thinkhub/src/application/splash/splash_state.dart';

class SplashBloc extends BaseBloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashState());
}
