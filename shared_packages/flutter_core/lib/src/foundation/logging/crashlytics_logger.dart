import '../monitoring/crash_reporter.dart';
import 'logger.dart';

class CrashlyticsLogger extends Logger {
  CrashlyticsLogger(this._crash);
  final CrashReporter _crash;

  @override
  void log(LogLevel level, String event, Map<String, Object?> ctx) {
    final data = {
      'level': level.name,
      'event': event,
      'ctx': ctx.map((k, v) => MapEntry(k, _sanitize(v))),
    };

    if (level.index >= LogLevel.warn.index) {
      _crash.recordError(
        Exception('[${level.name}] $event'),
        StackTrace.current,
        context: data.map((k, v) => MapEntry('log.$k', v)),
      );
    } else {
      _crash.log('$event $data');
    }
  }

  Object? _sanitize(Object? v) =>
      v is num || v is bool || v is String || v == null ? v : v.toString();
}
