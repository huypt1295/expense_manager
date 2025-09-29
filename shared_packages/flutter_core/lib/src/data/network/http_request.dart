/// Immutable HTTP request description consumed by [HttpClient].
class HttpRequest {
  final String method;
  final Uri url;
  final Map<String, String> headers;
  final Object? body;
  final Duration? timeout;

  /// URL query parameters that should be appended to [url].
  final Map<String, dynamic>? queryParameters;
  /// Flag to override retry behaviour for this request (true = force, false = disable).
  final bool? retryOverride;
  /// Optional cancel token (Dio's [CancelToken] or any adapter-specific object).
  final Object? cancelToken;

  const HttpRequest({
    required this.method,
    required this.url,
    this.headers = const {},
    this.body,
    this.timeout,
    this.queryParameters,
    this.retryOverride,
    this.cancelToken,
  });

  /// Returns a copy of this request with overridden fields.
  HttpRequest copyWith({
    String? method,
    Uri? url,
    Map<String, String>? headers,
    Object? body,
    Duration? timeout,
    Map<String, dynamic>? queryParameters,
    bool? retryOverride,
    Object? cancelToken,
  }) => HttpRequest(
    method: method ?? this.method,
    url: url ?? this.url,
    headers: headers ?? this.headers,
    body: body ?? this.body,
    timeout: timeout ?? this.timeout,
    queryParameters: queryParameters ?? this.queryParameters,
    retryOverride: retryOverride ?? this.retryOverride,
    cancelToken: cancelToken ?? this.cancelToken,
  );
}
