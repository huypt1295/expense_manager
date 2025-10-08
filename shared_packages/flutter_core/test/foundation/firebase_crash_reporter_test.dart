import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_core/src/foundation/monitoring/adapters/firebase_crash_reporter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrashlytics extends Mock implements FirebaseCrashlytics {}

void main() {
  setUpAll(() {
    registerFallbackValue(<String, Object?>{});
  });

  test('FirebaseCrashReporter forwards init and enabled flag respecting debug mode', () async {
    final fx = _MockCrashlytics();
    final reporter = FirebaseCrashReporter(fx);
    when(() => fx.setCrashlyticsCollectionEnabled(any())).thenAnswer((_) async {});

    await reporter.init();
    await reporter.setEnabled(true);

    verify(() => fx.setCrashlyticsCollectionEnabled(!kDebugMode)).called(1);
    verify(() => fx.setCrashlyticsCollectionEnabled(true)).called(1);
  });

  test('FirebaseCrashReporter records errors with sanitized context', () async {
    final fx = _MockCrashlytics();
    final reporter = FirebaseCrashReporter(fx);

    when(() => fx.setCustomKey(any(), any())).thenAnswer((_) async {});
    when(() => fx.recordError(any(), any(), fatal: any(named: 'fatal'), printDetails: any(named: 'printDetails')))
        .thenAnswer((_) async {});
    when(() => fx.log(any())).thenAnswer((_) async {});
    when(() => fx.setUserIdentifier(any())).thenAnswer((_) async {});

    reporter.recordError(Exception('boom'), StackTrace.empty, context: {'answer': 42});
    reporter.log('message', data: {'tag': 'value'});
    reporter.addBreadcrumb('crumb', category: 'nav', data: {'id': 1});
    reporter.setUser(id: 'u1', email: 'e@mail', name: 'User');
    reporter.setCustomKey('k', DateTime(2020));
    reporter.setCustomKeys({'flag': true});

    verify(() => fx.setCustomKey('answer', 42)).called(1);
    verify(() => fx.recordError(any(), any(), fatal: false, printDetails: false)).called(1);
    verify(() => fx.log('message')).called(1);
    verify(() => fx.setCustomKey('log.tag', 'value')).called(1);
    verify(() => fx.log('[nav] crumb')).called(1);
    verify(() => fx.setCustomKey('crumb.id', 1)).called(1);
    verify(() => fx.setUserIdentifier('u1')).called(1);
    verify(() => fx.setCustomKey('user.email', 'e@mail')).called(1);
    verify(() => fx.setCustomKey('user.name', 'User')).called(1);
    verify(() => fx.setCustomKey('k', '2020-01-01 00:00:00.000')).called(1);
    verify(() => fx.setCustomKey('flag', true)).called(1);
  });

  test('FirebaseCrashReporter converts FlutterErrorDetails into crash reports', () {
    final fx = _MockCrashlytics();
    final reporter = FirebaseCrashReporter(fx);

    when(() => fx.setCustomKey(any(), any())).thenAnswer((_) async {});
    when(() => fx.recordError(any(), any(), fatal: any(named: 'fatal'), printDetails: any(named: 'printDetails')))
        .thenAnswer((_) async {});

    final details = FlutterErrorDetails(exception: 'boom', library: 'lib', context: ErrorDescription('ctx'));
    reporter.recordFlutterError(details);

    verify(() => fx.recordError('boom', details.stack, fatal: false, printDetails: false)).called(1);
    verify(() => fx.setCustomKey('library', 'lib')).called(1);
    verify(() => fx.setCustomKey('context', 'ctx')).called(1);
  });
}
