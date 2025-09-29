import '../http_request.dart';
import '../http_response.dart';
import 'http_interceptor.dart';

/// Executes a list of [HttpInterceptor]s in a request/response pipeline.
class InterceptorChain {
  final List<HttpInterceptor> _interceptors;

  InterceptorChain(this._interceptors);

  /// Executes [onRequest] on each interceptor in declaration order.
  Future<HttpRequest> proceedRequest(HttpRequest req) async {
    var r = req;
    for (final i in _interceptors) {
      r = await i.onRequest(r);
    }
    return r;
  }

  /// Executes [onResponse] on each interceptor in reverse order.
  Future<HttpResponse> proceedResponse(HttpResponse res) async {
    var rr = res;
    for (final i in _interceptors.reversed) {
      rr = await i.onResponse(rr);
    }
    return rr;
  }

  /// Executes [onError] on each interceptor in reverse order until one recovers.
  Future<HttpResponse> proceedError(Object e, StackTrace s, HttpRequest req) async {
    Object err = e;
    StackTrace st = s;
    for (final i in _interceptors.reversed) {
      try {
        return await i.onError(err, st, req);
      } catch (ee, ss) {
        err = ee;
        st = ss;
      }
    }
    Error.throwWithStackTrace(err, st);
  }
}
