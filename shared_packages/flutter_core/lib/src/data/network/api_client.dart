import 'package:dio/dio.dart';
import 'package:flutter_core/flutter_core.dart' show HttpStatusException;
import 'package:flutter_core/src/data/network/retry_policies.dart'
    show RetryPolicy, defaultPolicy;

// final dio = Dio(BaseOptions(
//   baseUrl: 'https://api.example.com',
//   // validateStatus cho phép nhận mọi status, mình tự throw sau
//   validateStatus: (_) => true,
// ));
//
// // tuỳ chỉnh policy (3 lần, backoff 200ms→400→800, max 2s, retry chỉ khi timeout/5xx/429/408)
// final client = ApiClient(
//   dio,
//   policy: defaultPolicy,
//   // retryNonIdempotent: true, // bật nếu bạn dùng Idempotency-Key cho POST/PUT/PATCH
// );
//
// // ví dụ gọi GET
// final user = await client.request<UserDto>(
// method: RestMethod.get,
// path: '/users/123',
// decoder: (json) => UserDto.fromJson(json),
// );
//
// // ví dụ POST với idempotency-key để cho phép retry an toàn
// final create = await client.request<CreatePaymentResponse>(
// method: RestMethod.post,
// path: '/payments',
// body: payload.toJson(),
// options: Options(headers: {'Idempotency-Key': const Uuid().v4()}),
// decoder: (json) => CreatePaymentResponse.fromJson(json),
// );

typedef Decoder<T> = T Function(dynamic data);

enum RestMethod { get, post, put, patch, delete }

class ApiClient {
  final Dio _dio;
  final RetryPolicy _policy;
  final bool
      retryNonIdempotent; // Chỉ nên bật nếu server hỗ trợ idempotency-key

  ApiClient(
    this._dio, {
    RetryPolicy policy = defaultPolicy,
    this.retryNonIdempotent = false,
  }) : _policy = policy;

  Future<T> request<T>({
    required RestMethod method,
    required String path,
    Map<String, dynamic>? query,
    Object? body,
    Options? options,
    required Decoder<T> decoder, // bắt buộc: ép kiểu an toàn
    CancelToken? cancelToken,
    bool? retryOverride, // ép bật/tắt retry cho request này
  }) async {
    final bool allowRetry = retryOverride ??
        _isIdempotent(method) ||
            (retryNonIdempotent && _hasIdempotencyKey(options));

    final Response res = await _withRetry(
      call: () => _requestByMethod(
        method: method,
        path: _normalizePath(path),
        query: query,
        body: method == RestMethod.get ? null : body,
        // tránh body cho GET
        options: options,
        cancelToken: cancelToken,
      ),
      allowRetry: allowRetry,
    );

    // Tự chuẩn hoá statusCode thất bại thành Exception để control
    _throwIfHttpError(res);

    // OK, decode
    return decoder(res.data);
  }

  Future<Response<dynamic>> _requestByMethod({
    required RestMethod method,
    required String path,
    Map<String, dynamic>? query,
    Object? body,
    Options? options,
    CancelToken? cancelToken,
  }) {
    switch (method) {
      case RestMethod.get:
        return _dio.get(path,
            queryParameters: query, options: options, cancelToken: cancelToken);
      case RestMethod.post:
        return _dio.post(path,
            data: body,
            queryParameters: query,
            options: options,
            cancelToken: cancelToken);
      case RestMethod.put:
        return _dio.put(path,
            data: body,
            queryParameters: query,
            options: options,
            cancelToken: cancelToken);
      case RestMethod.patch:
        return _dio.patch(path,
            data: body,
            queryParameters: query,
            options: options,
            cancelToken: cancelToken);
      case RestMethod.delete:
        return _dio.delete(path,
            data: body,
            queryParameters: query,
            options: options,
            cancelToken: cancelToken);
    }
  }

  // ----------------------------
  // Retry wrapper
  // ----------------------------
  Future<Response> _withRetry({
    required Future<Response> Function() call,
    required bool allowRetry,
  }) async {
    int attempt = 0;
    while (true) {
      attempt++;
      try {
        final res = await call();

        // Nếu bạn muốn retry dựa trên response (vd 5xx/429) dù không throw
        if (_shouldRetryResponse(res) &&
            allowRetry &&
            attempt < _policy.backoff.maxRetries) {
          await Future.delayed(_policy.backoff.delay(attempt));
          continue;
        }
        return res;
      } on DioException catch (e) {
        if (!allowRetry ||
            attempt >= _policy.backoff.maxRetries ||
            !_policy.shouldRetry(e, attempt)) {
          rethrow;
        }
        await Future.delayed(_policy.backoff.delay(attempt));
      } catch (e) {
        // Lỗi không thuộc DioException: thường là lập trình/parse → không retry
        rethrow;
      }
    }
  }

  bool _shouldRetryResponse(Response res) {
    final sc = res.statusCode ?? 0;
    // retry transient: 5xx, 429, 408
    return sc >= 500 || sc == 429 || sc == 408;
  }

  void _throwIfHttpError(Response res) {
    final sc = res.statusCode ?? 0;
    if (sc >= 400) {
      throw HttpStatusException(sc, body: _stringifySafe(res.data));
    }
  }

  String _normalizePath(String path) {
    // Nếu caller lỡ truyền full URL, cứ để Dio xử lý (Dio dùng baseUrl nếu path là relative)
    return path;
  }

  bool _isIdempotent(RestMethod m) =>
      m == RestMethod.get || m == RestMethod.delete;

  // delete thường idempotent về semantics REST, tuy nhiên cẩn thận với business side-effects.

  bool _hasIdempotencyKey(Options? options) {
    final headers = options?.headers;
    return headers != null && headers.containsKey('Idempotency-Key');
  }

  String? _stringifySafe(dynamic data) {
    try {
      if (data == null) return null;
      if (data is String) return data;
      return data.toString();
    } catch (_) {
      return null;
    }
  }
}
