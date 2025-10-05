import 'dart:convert';

import 'logger.dart';

/// [`Logger`] that prints structured entries to the developer console.
class ConsoleLogger extends Logger {
  ConsoleLogger({void Function(String message)? printer})
      : _printer = printer ?? print;

  final void Function(String message) _printer;

  @override
  void log(LogLevel level, String event, Map<String, Object?> ctx) {
    final ts = DateTime.now().toIso8601String();
    final payload = ctx.isEmpty ? '' : ' ${jsonEncode(_serialize(ctx))}';
    _printer('[${level.name.toUpperCase()}] $ts $event$payload');
  }

  Map<String, Object?> _serialize(Map<String, Object?> ctx) =>
      ctx.map((key, value) => MapEntry(key, _coerce(value)));

  Object? _coerce(Object? value) {
    if (value == null || value is num || value is bool || value is String) {
      return value;
    }
    if (value is Iterable) {
      return value.map(_coerce).toList();
    }
    if (value is Map) {
      return (value.cast<Object?, Object?>())
          .map((k, v) => MapEntry(k?.toString() ?? 'null', _coerce(v)));
    }
    return value.toString();
  }
}
