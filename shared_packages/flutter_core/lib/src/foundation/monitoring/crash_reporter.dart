import 'package:flutter/foundation.dart';

/// Contract for reporting crashes and non-fatal errors to a monitoring system.
abstract class CrashReporter {
  /// Performs initialization for the underlying crash reporting SDK.
  Future<void> init();

  /// Enables or disables crash reporting collection.
  Future<void> setEnabled(bool enabled);

  /// Records the given [error] and [stack] with optional metadata.
  void recordError(
    Object error,
    StackTrace? stack, {
      bool fatal = false,
      Map<String, Object?>? context,
    });

  /// Convenience helper that converts [FlutterErrorDetails] into a crash report.
  void recordFlutterError(FlutterErrorDetails details) {
    recordError(details.exception, details.stack, context: {
      'library': details.library,
      'information': details.informationCollector?.call().join('\n'),
      'context': details.context?.toDescription(),
    });
  }

  /// Logs a textual message accompanied by structured [data].
  void log(String message, {Map<String, Object?>? data});

  /// Adds a breadcrumb describing intermediate application state.
  void addBreadcrumb(
    String message, {
      String? category,
      Map<String, Object?>? data,
      String? level,
      });

  /// Associates crash reports with a specific user.
  void setUser({String? id, String? email, String? name});

  /// Sets a single custom metadata key.
  void setCustomKey(String key, Object? value);

  /// Sets multiple custom metadata keys at once.
  void setCustomKeys(Map<String, Object?> keys);
}

/// Crash reporter implementation that discards every request.
class NoopCrashReporter implements CrashReporter {
  @override
  Future<void> init() async {}

  @override
  Future<void> setEnabled(bool enabled) async {}

  @override
  void recordError(Object e, StackTrace? s, {bool fatal = false, Map<String, Object?>? context}) {}

  @override
  void recordFlutterError(FlutterErrorDetails d) {}

  @override
  void log(String message, {Map<String, Object?>? data}) {}

  @override
  void addBreadcrumb(String message, {String? category, Map<String, Object?>? data, String? level}) {}

  @override
  void setUser({String? id, String? email, String? name}) {}

  @override
  void setCustomKey(String key, Object? value) {}

  @override
  void setCustomKeys(Map<String, Object?> keys) {}
}
