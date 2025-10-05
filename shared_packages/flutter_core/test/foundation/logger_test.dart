import 'package:flutter_core/src/foundation/logging/console_logger.dart';
import 'package:flutter_core/src/foundation/logging/logger.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingLogger extends Logger {
  final List<(LogLevel level, String event, Map<String, Object?> ctx)> entries =
      [];

  @override
  void log(LogLevel level, String event, Map<String, Object?> ctx) {
    entries.add((level, event, ctx));
  }
}

void main() {
  group('Logger convenience helpers', () {
    test('delegate to log with matching level', () {
      final logger = _RecordingLogger();

      logger.debug('debug', {'id': 1});
      logger.info('info');
      logger.warn('warn', {'flag': true});
      logger.error('error', {'message': 'oops'});

      expect(logger.entries.length, 4);
      expect(logger.entries[0].$1, LogLevel.debug);
      expect(logger.entries[0].$2, 'debug');
      expect(logger.entries[0].$3, {'id': 1});

      expect(logger.entries[1].$1, LogLevel.info);
      expect(logger.entries[1].$2, 'info');
      expect(logger.entries[1].$3, const {});

      expect(logger.entries[2].$1, LogLevel.warn);
      expect(logger.entries[2].$3, {'flag': true});

      expect(logger.entries[3].$1, LogLevel.error);
      expect(logger.entries[3].$3, {'message': 'oops'});
    });
  });

  group('ConsoleLogger', () {
    test('prints structured payload', () {
      String? captured;
      final logger = ConsoleLogger(printer: (message) => captured = message);

      logger.warn('demo.event', {'id': 42, 'meta': {'flag': true}});

      expect(captured, isNotNull);
      expect(captured, contains('[WARN]'));
      expect(captured, contains('demo.event'));
      expect(captured, contains('"id":42'));
      expect(captured, contains('"flag":true'));
    });
  });
}
