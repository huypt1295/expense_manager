import '../http_request.dart';
import '../http_response.dart';

/// Lightweight interceptor contract to observe/transform HTTP traffic.
abstract class HttpInterceptor {
  /// Called before the request is dispatched. Return a modified [HttpRequest] if needed.
  Future<HttpRequest> onRequest(HttpRequest request) async => request;

  /// Called after a response is received. Return a modified [HttpResponse] if needed.
  Future<HttpResponse> onResponse(HttpResponse response) async => response;

  /// Intercepts errors so implementations can transform them or synthesize responses.
  /// Return a fallback [HttpResponse] to recover, or rethrow to propagate the error.
  Future<HttpResponse> onError(
    Object error,
    StackTrace stack,
    HttpRequest request,
  ) async {
    // Default: rethrow the original error with its stack trace.
    Error.throwWithStackTrace(error, stack);
  }
}
