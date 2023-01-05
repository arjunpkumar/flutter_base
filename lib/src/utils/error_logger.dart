import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class ErrorLogger {
  static final _instance = ErrorLogger._();
  late FirebaseCrashlytics _crashlytics;

  factory ErrorLogger() {
    return _instance;
  }

  ErrorLogger._() {
    _crashlytics = FirebaseCrashlytics.instance;
  }

  Future<void> recordError({
    required dynamic exception,
    required StackTrace stackTrace,
  }) async {
    if (exception is StateError) {
      if (exception.message ==
          'Bad state: Cannot add new events after calling close') {
        return;
      }
    }
    _crashlytics.recordError(exception, stackTrace);
  }
}
