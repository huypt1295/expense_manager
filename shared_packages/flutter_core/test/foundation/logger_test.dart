import 'package:flutter_core/src/foundation/logger.dart';
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
}
