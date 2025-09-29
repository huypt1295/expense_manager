import 'package:flutter_core/flutter_core.dart' show CrashReporter, Analytics;
import 'package:flutter_core/src/data/network/interceptor/http_interceptor.dart' show HttpInterceptor;
import 'package:injectable/injectable.dart';

import '../http_request.dart' show HttpRequest;
import '../http_response.dart' show HttpResponse;

/// Interceptor that records crash breadcrumbs and lightweight analytics per HTTP call.
/// PII is intentionally excluded; only host, method, status, and timing information is logged.
@lazySingleton
class CrashBreadcrumbInterceptor extends HttpInterceptor {
  final CrashReporter _crash;
  final Analytics _analytics;

  CrashBreadcrumbInterceptor(this._crash, this._analytics);

  @override
  Future<HttpRequest> onRequest(HttpRequest request) async {
    _crash.addBreadcrumb('HTTP ${request.method}',
        category: 'http',
        data: {
          'url_host': request.url.host,
          'method': request.method,
        });

    // Lightweight request counter metric.
    _analytics.logEvent('http_request', parameters: {
      'url_host': request.url.host,
      'method': request.method,
    });

    return request;
  }

  @override
  Future<HttpResponse> onResponse(HttpResponse response) async {
    _crash.addBreadcrumb('HTTP ${response.statusCode}',
        category: 'http',
        data: {
          'url_host': response.request.url.host,
          'method': response.request.method,
          'ok': response.isSuccessful,
          'dur_ms': response.duration?.inMilliseconds,
        });

    // Lightweight response metric.
    _analytics.logEvent('http_response', parameters: {
      'url_host': response.request.url.host,
      'method': response.request.method,
      'status': response.statusCode,
      'success': response.isSuccessful,
      'dur_ms': response.duration?.inMilliseconds,
    });

    return response;
  }

  @override
  Future<HttpResponse> onError(Object error, StackTrace stack, HttpRequest request) async {
    _crash.recordError(error, stack, context: {
      'http.url_host': request.url.host,
      'http.method': request.method,
    });

    _analytics.logEvent('http_error', parameters: {
      'url_host': request.url.host,
      'method': request.method,
      'error_type': error.runtimeType.toString(),
    });

    // Rethrow by delegating to the base implementation.
    return super.onError(error, stack, request);
  }
}
