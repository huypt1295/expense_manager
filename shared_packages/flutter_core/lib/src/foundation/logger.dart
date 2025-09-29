/// Log severity levels understood by the shared logging abstraction.
enum LogLevel { debug, info, warn, error }

/// Defines a simple logging contract that supports structured context data.
abstract class Logger {
  /// Emits a log [event] with a given [level] and contextual payload [ctx].
  void log(LogLevel level, String event, Map<String, Object?> ctx);

  /// Convenience helper for emitting a `debug` level log.
  void debug(String event, [Map<String, Object?> ctx = const {}]) =>
      log(LogLevel.debug, event, ctx);

  /// Convenience helper for emitting an `info` level log.
  void info(String event, [Map<String, Object?> ctx = const {}]) =>
      log(LogLevel.info, event, ctx);

  /// Convenience helper for emitting a `warn` level log.
  void warn(String event, [Map<String, Object?> ctx = const {}]) =>
      log(LogLevel.warn, event, ctx);

  /// Convenience helper for emitting an `error` level log.
  void error(String event, [Map<String, Object?> ctx = const {}]) =>
      log(LogLevel.error, event, ctx);
}

/// Provides a process-wide [Logger] instance accessible from any module.
class LoggerProvider {
  static Logger? instance;
}
