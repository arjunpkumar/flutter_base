import 'package:flutter_base/src/application/core/process_state.dart';

abstract class BaseBlocState {
  ProcessState processState = ProcessState.initial();
  bool canPop = true;

  /// [copyWith] method used to copy current state with another field
  BaseBlocState copyWith();
}
