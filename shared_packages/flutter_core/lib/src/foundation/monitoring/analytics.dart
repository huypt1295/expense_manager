/// Abstraction over analytics providers used by the application.
abstract class Analytics {
  /// Performs any required SDK initialization.
  Future<void> init();

  /// Enables or disables analytics data collection.
  Future<void> setEnabled(bool enabled);

  /// Associates the current session with the provided [id].
  Future<void> setUserId(String? id);

  /// Sets a single user property identified by [key].
  Future<void> setUserProperty(String key, String? value);

  /// Sets multiple user properties in one call.
  Future<void> setUserProperties(Map<String, String?> props);

  /// Records a custom analytics event with optional [parameters].
  Future<void> logEvent(
    String name, {
    Map<String, Object?> parameters = const {},
  });

  /// Reports that a screen with [screenName] (and optional [screenClass]) was viewed.
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  });

  /// Clears user identifiers and properties, typically on logout.
  Future<void> reset();
}

/// Analytics implementation that ignores every call.
class NoopAnalytics implements Analytics {
  @override
  Future<void> init() async {}

  @override
  Future<void> setEnabled(bool enabled) async {}

  @override
  Future<void> setUserId(String? id) async {}

  @override
  Future<void> setUserProperty(String key, String? value) async {}

  @override
  Future<void> setUserProperties(Map<String, String?> props) async {}

  @override
  Future<void> logEvent(String name, {Map<String, Object?> parameters = const {}}) async {}

  @override
  Future<void> logScreenView({required String screenName, String? screenClass}) async {}

  @override
  Future<void> reset() async {}
}
