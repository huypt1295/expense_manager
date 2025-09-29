import 'http_request.dart' show HttpRequest;

/// HTTP response wrapper used by the data layer to expose typed payloads.
class HttpResponse<T> {
  final HttpRequest request;
  final int statusCode;
  final Map<String, String> headers;
  /// Decoded response body (JSON map/list/string/etc.).
  final T? data;
  /// Total request duration including retries and interceptors.
  final Duration? duration;

  /// Returns true when the response status code is in the 2xx range.
  bool get isSuccessful => statusCode >= 200 && statusCode < 300;

  const HttpResponse({
    required this.request,
    required this.statusCode,
    this.headers = const {},
    this.data,
    this.duration,
  });
}
