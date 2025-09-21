enum LogLevel { debug, info, warn, error }

abstract class Logger {
  void log(LogLevel level, String event, Map<String, Object?> ctx);

  void debug(String event, [Map<String, Object?> ctx = const {}]) =>
      log(LogLevel.debug, event, ctx);

  void info(String event, [Map<String, Object?> ctx = const {}]) =>
      log(LogLevel.info, event, ctx);

  void warn(String event, [Map<String, Object?> ctx = const {}]) =>
      log(LogLevel.warn, event, ctx);

  void error(String event, [Map<String, Object?> ctx = const {}]) =>
      log(LogLevel.error, event, ctx);
}

class LoggerProvider {
  static Logger? instance;
}
