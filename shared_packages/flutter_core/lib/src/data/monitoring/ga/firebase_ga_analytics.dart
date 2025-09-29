import 'package:flutter/foundation.dart';
import 'package:flutter_core/flutter_core.dart'
    show Analytics, LazySingleton, FirebaseAnalytics;

/// Concrete [Analytics] implementation backed by Firebase Analytics.
@LazySingleton(as: Analytics)
class FirebaseGAAnalytics implements Analytics {
  final FirebaseAnalytics _fa = FirebaseAnalytics.instance;

  @override
  /// Initializes the analytics SDK and toggles collection based on build type.
  Future<void> init() async {
    // Disable analytics automatically in debug builds.
    await _fa.setAnalyticsCollectionEnabled(!kDebugMode);
  }

  @override
  /// Enables or disables analytics collection at runtime.
  Future<void> setEnabled(bool enabled) => _fa.setAnalyticsCollectionEnabled(enabled);

  @override
  /// Assigns a user identifier for analytics correlation.
  Future<void> setUserId(String? id) => _fa.setUserId(id: id);

  @override
  /// Sets a single user property.
  Future<void> setUserProperty(String key, String? value) =>
      _fa.setUserProperty(name: key, value: value);

  @override
  /// Sets multiple user properties, skipping null values.
  Future<void> setUserProperties(Map<String, String?> props) async {
    for (final e in props.entries) {
      await _fa.setUserProperty(name: e.key, value: e.value);
    }
  }

  @override
  /// Logs an analytics event with sanitized keys.
  Future<void> logEvent(String name, {Map<String, Object?> parameters = const {}}) {
    return _fa.logEvent(name: _sanitize(name), parameters: _sanitizeParams(parameters));
  }

  @override
  /// Logs the current screen view.
  Future<void> logScreenView({required String screenName, String? screenClass}) {
    return _fa.logScreenView(screenName: screenName, screenClass: screenClass);
  }

  @override
  /// Clears user-identifying state after logout flows.
  Future<void> reset() async {
    await _fa.setUserId(id: null);
    // GA4 does not expose a "clear user properties" API; clear sensitive properties manually.
  }

  /// Sanitizes [name] to comply with GA4 naming rules.
  String _sanitize(String name) {
    // GA4 expects: a-z0-9_, <= 40 chars, and cannot start with a digit.
    final n = name.toLowerCase().replaceAll(RegExp('[^a-z0-9_]'), '_');
    return n.startsWith(RegExp('[0-9]')) ? '_$n' : n;
  }

  /// Sanitizes parameter keys and coerces unsupported values to strings.
  Map<String, Object> _sanitizeParams(Map<String, Object?> m) {
    // Convert unsupported value types to string to avoid PII leaks.
    final out = <String, Object>{};
    m.forEach((k, v) {
      Object? vv = v;
      if (vv == null || vv is num || vv is String || vv is bool) {
        // ok
      } else {
        vv = vv.toString();
      }
      if (vv != null) {
        out[_sanitize(k)] = vv;
      }
    });
    return out;
  }
}
