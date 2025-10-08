import 'package:flutter_core/src/data/network/http_request.dart';
import 'package:flutter_core/src/data/network/http_response.dart';
import 'package:flutter_core/src/data/network/interceptor/breadcrumb_interceptor.dart';
import 'package:flutter_core/src/foundation/monitoring/analytics.dart';
import 'package:flutter_core/src/foundation/monitoring/crash_reporter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrashReporter extends Mock implements CrashReporter {}

class _MockAnalytics extends Mock implements Analytics {}

void main() {
  late _MockCrashReporter crash;
  late _MockAnalytics analytics;
  late CrashBreadcrumbInterceptor interceptor;
  late HttpRequest request;
  late HttpResponse response;

  setUp(() {
    crash = _MockCrashReporter();
    analytics = _MockAnalytics();
    interceptor = CrashBreadcrumbInterceptor(crash, analytics);

    request = HttpRequest(
      method: 'POST',
      url: Uri.parse('https://api.example.com/resource'),
    );
    response = HttpResponse(
      request: request,
      statusCode: 201,
      duration: const Duration(milliseconds: 42),
    );

    when(() => analytics.logEvent(any(), parameters: any(named: 'parameters')))
        .thenAnswer((_) async {});
    when(() => crash.addBreadcrumb(any(),
        category: any(named: 'category'),
        data: any(named: 'data'),
        level: any(named: 'level'))).thenReturn(null);
    when(() => crash.recordError(any(), any(), context: any(named: 'context')))
        .thenReturn(null);
    when(() => crash.log(any(), data: any(named: 'data'))).thenReturn(null);
  });

  test('onRequest records breadcrumb and analytics event', () async {
    final out = await interceptor.onRequest(request);
    expect(out, same(request));

    verify(() => crash.addBreadcrumb(
          'HTTP POST',
          category: 'http',
          data: {'url_host': 'api.example.com', 'method': 'POST'},
        )).called(1);

    verify(() => analytics.logEvent('http_request', parameters: {
          'url_host': 'api.example.com',
          'method': 'POST',
        })).called(1);
  });

  test('onResponse records breadcrumb and analytics event', () async {
    final out = await interceptor.onResponse(response);
    expect(out, same(response));

    verify(() => crash.addBreadcrumb(
          'HTTP 201',
          category: 'http',
          data: {
            'url_host': 'api.example.com',
            'method': 'POST',
            'ok': true,
            'dur_ms': 42,
          },
        )).called(1);

    verify(() => analytics.logEvent('http_response', parameters: {
          'url_host': 'api.example.com',
          'method': 'POST',
          'status': 201,
          'success': true,
          'dur_ms': 42,
        })).called(1);
  });

  test('onError forwards errors to crash reporter and analytics', () async {
    final error = StateError('boom');
    final stack = StackTrace.current;

    expect(
      () => interceptor.onError(error, stack, request),
      throwsA(isA<StateError>()),
    );

    verify(() => crash.recordError(error, stack, context: {
          'http.url_host': 'api.example.com',
          'http.method': 'POST',
        })).called(1);

    verify(() => analytics.logEvent('http_error', parameters: {
          'url_host': 'api.example.com',
          'method': 'POST',
          'error_type': 'StateError',
        })).called(1);
  });
}
