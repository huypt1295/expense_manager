import 'package:injectable/injectable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show FlutterErrorDetails, kDebugMode, DiagnosticsNode;
import '../../../foundation/monitoring/crash_reporter.dart';

/// [CrashReporter] implementation that forwards events to Firebase Crashlytics.
@LazySingleton(as: CrashReporter)
class FirebaseCrashReporter implements CrashReporter {
  final FirebaseCrashlytics _fx;
  FirebaseCrashReporter(this._fx);

  @override
  Future<void> init() async {
    await _fx.setCrashlyticsCollectionEnabled(!kDebugMode);
  }

  @override
  Future<void> setEnabled(bool enabled) => _fx.setCrashlyticsCollectionEnabled(enabled);

  @override
  void recordError(
      Object error,
      StackTrace? stack, {
        bool fatal = false,
        Map<String, Object?>? context,
      }) {
    if (context != null) {
      for (final e in context.entries) {
        _safeSetKey(e.key, e.value);
      }
    }
    _fx.recordError(error, stack, fatal: fatal, printDetails: false);
  }

  /// Forwards framework errors to Crashlytics while enriching the payload with
  /// additional diagnostic context.
  @override
  void recordFlutterError(FlutterErrorDetails details) {
    final info = details.informationCollector?.call();
    final infoText = info?.map((DiagnosticsNode n) => n.toDescription()).join('\n');

    recordError(
      details.exception,
      details.stack,
      context: {
        if (details.library != null) 'library': details.library!,
        if (details.context != null) 'context': details.context!.toDescription(),
        if (infoText != null && infoText.isNotEmpty) 'information': infoText,
      },
    );
  }

  @override
  void log(String message, {Map<String, Object?>? data}) {
    if (data != null) {
      for (final e in data.entries) {
        _safeSetKey('log.${e.key}', e.value);
      }
    }
    _fx.log(message);
  }

  @override
  void addBreadcrumb(
      String message, {
        String? category,
        Map<String, Object?>? data,
        String? level,
      }) {
    _fx.log('[${category ?? 'crumb'}] $message');
    data?.forEach((k, v) => _safeSetKey('crumb.$k', v));
  }

  @override
  void setUser({String? id, String? email, String? name}) {
    if (id != null) _fx.setUserIdentifier(id);
    if (email != null) _safeSetKey('user.email', email);
    if (name != null) _safeSetKey('user.name', name);
  }

  @override
  void setCustomKey(String key, Object? value) => _safeSetKey(key, value);

  @override
  void setCustomKeys(Map<String, Object?> keys) => keys.forEach(_safeSetKey);

  /// Writes a Crashlytics custom key ensuring the value is serializable.
  void _safeSetKey(String key, Object? value) {
    if (value == null) return;
    if (value is num || value is bool || value is String) {
      _fx.setCustomKey(key, value);
    } else {
      _fx.setCustomKey(key, value.toString());
    }
  }
}
