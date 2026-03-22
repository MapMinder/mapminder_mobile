import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static AppLogger? _instance;

  factory AppLogger() {
    _instance ??= AppLogger._();
    return _instance!;
  }

  final logger = Logger(
    printer: PrettyPrinter(),
  );

  AppLogger._();

  void debug(String message) {
    if (!kReleaseMode) {
      logger.d(message);
    }
  }
  void info(String message) {
    if (!kReleaseMode) {
      logger.i(message);
    }
  }
  void warn(String message) {
    if (!kReleaseMode) {
      logger.w(message);
    }
  }
  void error(String message, Object? e, StackTrace? s) {
    if (!kReleaseMode) {
      if (e != null) {
        logger.e(message, error: e, stackTrace: s);
      } else {
        logger.e(message);
      }
    }
  }
}
