import 'package:flutter/material.dart';
import 'package:flutter_core/src/presentation/navigation/ga_route_observer.dart';
import 'package:flutter_core/src/presentation/navigation/crash_route_observer.dart';
import 'package:flutter_core/src/foundation/logging/logger.dart' show LogLevel;
import 'package:flutter_core/src/foundation/logger.dart' as legacy_logger;
import 'package:flutter_core/src/foundation/monitoring/analytics.dart';
import 'package:flutter_core/src/foundation/monitoring/crash_reporter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAnalytics extends Mock implements Analytics {}

class _MockCrashReporter extends Mock implements CrashReporter {}

class _MockLogger extends Mock implements legacy_logger.Logger {}

void main() {
  setUpAll(() {
    registerFallbackValue(<String, Object?>{});
    registerFallbackValue(LogLevel.debug);
  });

  test('GARouteObserver logs screen views on navigation events', () {
    final analytics = _MockAnalytics();
    final observer = GARouteObserver(analytics);
    final logger = _MockLogger();
    legacy_logger.LoggerProvider.instance = logger;
    addTearDown(() => legacy_logger.LoggerProvider.instance = null);

    when(() => analytics.logScreenView(screenName: any(named: 'screenName'), screenClass: any(named: 'screenClass')))
        .thenAnswer((_) async {});
    when(() => logger.debug(any(), any())).thenReturn(null);

    final route = MaterialPageRoute(builder: (_) => const SizedBox.shrink(), settings: const RouteSettings(name: 'home'));
    final other = MaterialPageRoute(builder: (_) => const SizedBox.shrink(), settings: const RouteSettings(name: 'detail'));

    observer.didPush(route, null);
    observer.didReplace(newRoute: other, oldRoute: route);
    observer.didPop(other, route);

    verify(() => analytics.logScreenView(screenName: 'detail', screenClass: other.runtimeType.toString())).called(1);
    verify(() => analytics.logScreenView(screenName: 'home', screenClass: route.runtimeType.toString())).called(2);
  });

  test('CrashRouteObserver records breadcrumbs for navigation changes', () {
    final crash = _MockCrashReporter();
    final observer = CrashRouteObserver(crash);

    when(() => crash.addBreadcrumb(any(), category: any(named: 'category'), data: any(named: 'data')))
        .thenReturn(null);

    final route = MaterialPageRoute(builder: (_) => const SizedBox.shrink(), settings: const RouteSettings(name: 'feed'));
    final other = MaterialPageRoute(builder: (_) => const SizedBox.shrink(), settings: const RouteSettings(name: 'profile'));

    observer.didPush(route, null);
    observer.didReplace(newRoute: other, oldRoute: route);
    observer.didPop(other, route);

    verify(() => crash.addBreadcrumb('route.push', category: 'navigation', data: {'name': 'feed'})).called(1);
    verify(() => crash.addBreadcrumb('route.replace', category: 'navigation', data: {'name': 'profile'})).called(1);
    verify(() => crash.addBreadcrumb('route.pop', category: 'navigation', data: {'name': 'feed'})).called(1);
  });
}
