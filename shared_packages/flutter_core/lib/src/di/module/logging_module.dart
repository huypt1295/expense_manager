import 'package:flutter/foundation.dart';
import 'package:flutter_core/flutter_core.dart';
// import 'package:flutter_core/src/foundation/logging/analytics_logger.dart';
import 'package:flutter_core/src/foundation/logging/console_logger.dart';
// import 'package:flutter_core/src/foundation/logging/crashlytics_logger.dart';

/// Provides the default logging implementation for the shared module.
@module
abstract class LoggingModule {
  @lazySingleton
  Logger logger(
      CrashReporter crash,
      Analytics analytics,
      ) {
    return MultiLogger([
      ConsoleLogger(printer: debugPrint),
      // CrashlyticsLogger(crash), // uncomment to enable crashlytics log
      // AnalyticsLogger(analytics), // uncomment to enable analytics log
    ]);
  }
}

