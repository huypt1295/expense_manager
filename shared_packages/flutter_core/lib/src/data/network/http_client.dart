import 'dart:convert' show jsonEncode;

import 'package:dio/dio.dart' show CancelToken, Dio, Options;
import 'package:flutter_core/src/data/network/interceptor/http_interceptor.dart'
    show HttpInterceptor;
import 'package:flutter_core/src/data/network/interceptor/interceptor_chain.dart'
    show InterceptorChain;
import 'package:flutter_core/src/data/network/retry_policies.dart';
import 'package:injectable/injectable.dart';

import 'http_request.dart';
import 'http_response.dart';

/// Abstraction for sending typed HTTP requests.
abstract class HttpClient {
  /// Sends [request] and returns a typed [HttpResponse].
  Future<HttpResponse<T>> send<T>(HttpRequest request);
}

/// [HttpClient] implementation backed by Dio with retry and interceptor support.
@LazySingleton(as: HttpClient)
class DioHttpClient implements HttpClient {
  final Dio _dio;
  final InterceptorChain _chain;
  final RetryPolicy _policy;
  // Allows retrying non-idempotent calls when an Idempotency-Key is present.
  final bool _retryNonIdempotent;

  DioHttpClient(
    Dio dio,
    @Named('networkInterceptors') List<HttpInterceptor> interceptors, {
    @Named('networkRetryPolicy') RetryPolicy? policy,
    @Named('networkRetryNonIdempotent') bool retryNonIdempotent = false,
  })  : _dio = dio,
        _chain = InterceptorChain(interceptors),
        _policy = policy ?? defaultPolicy,
        _retryNonIdempotent = retryNonIdempotent {
    // Let the client decide which statuses are considered errors.
    _dio.options.validateStatus = (status) => true;
  }

  @override
  Future<HttpResponse<T>> send<T>(HttpRequest request) async {
    final started = DateTime.now();

    // Retry loop state.
    int attempt = 0;
    final allowRetry = _computeAllowRetry(request);

    while (true) {
      attempt++;
      // Trace retry attempt in the headers without leaking PII.
      final reqAttempt = request.copyWith(
        headers: {
          ...request.headers,
          'x-retry-attempt': attempt.toString(),
        },
      );

      // 1) Interceptors: onRequest (per attempt).
      final req = await _chain.proceedRequest(reqAttempt);

      try {
        final resp = await _dio.request<Object?>(
          req.url.toString(),
          data: _bodyFor(req),
          queryParameters: req.queryParameters,
          options: Options(
            method: req.method,
            headers: req.headers,
            sendTimeout: req.timeout,
            receiveTimeout: req.timeout,
          ),
          cancelToken: req.cancelToken is CancelToken
              ? req.cancelToken as CancelToken
              : null,
        );

        final dur = DateTime.now().difference(started);
        var out = HttpResponse<T>(
          request: req,
          statusCode: resp.statusCode ?? -1,
          headers: resp.headers.map.map((k, v) => MapEntry(k, v.join(','))),
          data: _coerce<T>(resp.data),
          duration: dur,
        );

        // 2) Retry transient responses when allowed.
        if (_shouldRetryResponse(out) && allowRetry && attempt < _policy.backoff.maxRetries) {
          await Future.delayed(_policy.backoff.delay(attempt));
          continue;
        }

        // 3) Interceptors: onResponse.
        out = await _chain.proceedResponse(out) as HttpResponse<T>;
        return out;
      } catch (e, s) {
        // Allow interceptors to convert an error into a response before retrying.
        try {
          final handled = await _chain.proceedError(e, s, req) as HttpResponse<T>;
          // Converted into a response -> evaluate retry rules again.
          if (_shouldRetryResponse(handled) && allowRetry && attempt < _policy.backoff.maxRetries) {
            await Future.delayed(_policy.backoff.delay(attempt));
            continue;
          }
          return handled;
        } catch (ee, ss) {
          // Decide on retry based on the configured policy.
          final canRetry = allowRetry &&
              attempt < _policy.backoff.maxRetries &&
              _policy.shouldRetry(ee, attempt);

          if (!canRetry) {
            // No more retries: rethrow the last error.
            Error.throwWithStackTrace(ee, ss);
          }
          await Future.delayed(_policy.backoff.delay(attempt));
          // Continue with the next attempt.
        }
      }
    }
  }

  // -----------------------
  // Helpers
  // -----------------------

  /// Determines whether the given request is eligible for retry.
  bool _computeAllowRetry(HttpRequest r) {
    final override = r.retryOverride;
    if (override != null) return override;
    if (_isIdempotent(r.method)) return true;
    if (_retryNonIdempotent && _hasIdempotencyKey(r.headers)) return true;
    return false;
  }

  /// Returns true when [m] is an idempotent HTTP verb.
  bool _isIdempotent(String m) {
    final mm = m.toUpperCase();
    return mm == 'GET' || mm == 'DELETE' || mm == 'HEAD' || mm == 'OPTIONS';
  }

  /// Checks whether the request headers carry an Idempotency-Key.
  bool _hasIdempotencyKey(Map<String, String> headers) {
    return headers.keys.any((k) => k.toLowerCase() == 'idempotency-key');
  }

  /// Returns true when the response status hints at a transient failure.
  bool _shouldRetryResponse(HttpResponse res) {
    final sc = res.statusCode;
    return sc >= 500 || sc == 429 || sc == 408;
  }

  /// Prepares the request body for Dio, respecting HTTP semantics.
  Object? _bodyFor(HttpRequest r) {
    // Avoid sending a body for GET/HEAD to comply with strict servers.
    final mm = r.method.toUpperCase();
    if (mm == 'GET' || mm == 'HEAD') return null;
    return r.body;
  }

  /// Coerces Dio's raw response into the expected type [T].
  T? _coerce<T>(Object? raw) {
    if (raw == null) return null;
    if (T == Object || T == dynamic) return raw as T;
    if (T == String) {
      if (raw is String) return raw as T;
      return jsonEncode(raw) as T;
    }
    return raw as T;
  }
}
