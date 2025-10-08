import 'package:flutter_core/src/foundation/logging/analytics_logger.dart';
import 'package:flutter_core/src/foundation/logging/console_logger.dart';
import 'package:flutter_core/src/foundation/logging/crashlytics_logger.dart';
import 'package:flutter_core/src/foundation/logging/logger.dart';
import 'package:flutter_core/src/foundation/monitoring/analytics.dart';
import 'package:flutter_core/src/foundation/monitoring/crash_reporter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAnalytics extends Mock implements Analytics {}

class _MockCrashReporter extends Mock implements CrashReporter {}

class _MockLogger extends Mock implements Logger {}

void main() {
  setUpAll(() {
    registerFallbackValue(LogLevel.debug);
    registerFallbackValue(<String, Object?>{});
  });

  group('AnalyticsLogger', () {
    late _MockAnalytics analytics;
    late AnalyticsLogger logger;

    setUp(() {
      analytics = _MockAnalytics();
      logger = AnalyticsLogger(analytics);
      when(() => analytics.logEvent(any(), parameters: any(named: 'parameters')))
          .thenAnswer((_) async {});
    });

    test('ignores debug level logs', () async {
      logger.log(LogLevel.debug, 'event', const {'value': 1});
      verifyNever(() => analytics.logEvent(any(), parameters: any(named: 'parameters')));
    });

    test('forwards warn level logs with sanitized context', () async {
      logger.log(LogLevel.warn, 'event', {
        'list': [1, DateTime(2020, 1, 1)],
      });

      final captured = verify(
        () => analytics.logEvent('log_warn', parameters: captureAny(named: 'parameters')),
      ).captured.single as Map<String, Object?>;

      expect(captured['event'], 'event');
      expect(captured['list'], '[1, 2020-01-01 00:00:00.000]');
    });
  });

  group('CrashlyticsLogger', () {
    late _MockCrashReporter crash;
    late CrashlyticsLogger logger;

    setUp(() {
      crash = _MockCrashReporter();
      logger = CrashlyticsLogger(crash);
      when(() => crash.recordError(any(), any(), fatal: any(named: 'fatal'), context: any(named: 'context')))
          .thenReturn(null);
      when(() => crash.log(any(), data: any(named: 'data'))).thenReturn(null);
    });

    test('records errors for warn level', () {
      logger.log(LogLevel.warn, 'warn_event', {'foo': DateTime(2020)});

      verify(() => crash.recordError(
            any(that: isA<Exception>()),
            any(),
            context: {
              'log.level': 'warn',
              'log.event': 'warn_event',
              'log.ctx': {'foo': '2020-01-01 00:00:00.000'},
            },
          )).called(1);
    });

    test('logs message for info level', () {
      logger.log(LogLevel.info, 'info_event', const {'key': 'value'});

      verify(() => crash.log('info_event {level: info, event: info_event, ctx: {key: value}}'))
          .called(1);
    });
  });

  test('ConsoleLogger prints structured logs', () {
    final messages = <String>[];
    final logger = ConsoleLogger(printer: messages.add);

    logger.log(LogLevel.error, 'error', {
      'map': {'nested': 1},
    });

    expect(messages.single, contains('ERROR'));
    expect(messages.single, contains('"map"'));
  });

  test('MultiLogger forwards to delegates', () {
    final first = _MockLogger();
    final second = _MockLogger();
    final multi = MultiLogger([first, second]);

    when(() => first.log(any(), any(), any())).thenReturn(null);
    when(() => second.log(any(), any(), any())).thenReturn(null);

    multi.log(LogLevel.error, 'event', const {});

    verify(() => first.log(LogLevel.error, 'event', const {})).called(1);
    verify(() => second.log(LogLevel.error, 'event', const {})).called(1);
  });
}
