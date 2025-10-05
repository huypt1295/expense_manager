import '../monitoring/analytics.dart';
import 'logger.dart';

class AnalyticsLogger extends Logger {
  AnalyticsLogger(this._analytics);

  final Analytics _analytics;

  @override
  void log(LogLevel level, String event, Map<String, Object?> ctx) {
    if (level.index < LogLevel.info.index) return;

    _analytics.logEvent(
      'log_${level.name}',
      parameters: {
        'event': event,
        ...ctx.map((k, v) => MapEntry(k, _sanitize(v))),
      },
    );
  }

  Object? _sanitize(Object? v) =>
      v is num || v is bool || v is String || v == null ? v : v.toString();
}
