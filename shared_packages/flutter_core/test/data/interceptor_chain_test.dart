import 'package:flutter_core/src/data/network/http_request.dart';
import 'package:flutter_core/src/data/network/http_response.dart';
import 'package:flutter_core/src/data/network/interceptor/http_interceptor.dart';
import 'package:flutter_core/src/data/network/interceptor/interceptor_chain.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestInterceptor extends HttpInterceptor {
  _TestInterceptor({this.onReq, this.onRes, this.onErr});

  final Future<HttpRequest> Function(HttpRequest req)? onReq;
  final Future<HttpResponse> Function(HttpResponse res)? onRes;
  final Future<HttpResponse> Function(
    Object err,
    StackTrace st,
    HttpRequest req,
  )?
  onErr;

  @override
  Future<HttpRequest> onRequest(HttpRequest request) async {
    if (onReq != null) return onReq!(request);
    return super.onRequest(request);
  }

  @override
  Future<HttpResponse> onResponse(HttpResponse response) async {
    if (onRes != null) return onRes!(response);
    return super.onResponse(response);
  }

  @override
  Future<HttpResponse> onError(
    Object error,
    StackTrace stack,
    HttpRequest request,
  ) {
    if (onErr != null) return onErr!(error, stack, request);
    return super.onError(error, stack, request);
  }
}

void main() {
  final request = HttpRequest(
    method: 'GET',
    url: Uri.parse('https://example.com'),
  );

  group('InterceptorChain', () {
    test('runs request interceptors in declaration order', () async {
      final calls = <String>[];
      final chain = InterceptorChain([
        _TestInterceptor(
          onReq: (req) async {
            calls.add('a');
            return req.copyWith(headers: {...req.headers, 'x': '1'});
          },
        ),
        _TestInterceptor(
          onReq: (req) async {
            calls.add('b');
            return req.copyWith(headers: {...req.headers, 'y': '2'});
          },
        ),
      ]);

      final out = await chain.proceedRequest(request);

      expect(calls, ['a', 'b']);
      expect(out.headers, {'x': '1', 'y': '2'});
    });

    test('runs response interceptors in reverse order', () async {
      final calls = <String>[];
      final res = HttpResponse<String>(
        request: request,
        statusCode: 200,
        data: 'ok',
      );
      final chain = InterceptorChain([
        _TestInterceptor(
          onRes: (response) async {
            calls.add('first');
            return response;
          },
        ),
        _TestInterceptor(
          onRes: (response) async {
            calls.add('second');
            return HttpResponse<String>(
              request: response.request,
              statusCode: response.statusCode,
              headers: response.headers,
              data: 'patched',
              duration: response.duration,
            );
          },
        ),
      ]);

      final out = await chain.proceedResponse(res) as HttpResponse<String>;

      expect(calls, ['second', 'first']);
      expect(out.data, 'patched');
    });

    test('allows interceptors to recover from errors', () async {
      final chain = InterceptorChain([
        _TestInterceptor(
          onErr: (error, stack, req) async {
            throw StateError('unhandled');
          },
        ),
        _TestInterceptor(
          onErr: (error, stack, req) async {
            return HttpResponse<String>(
              request: req,
              statusCode: 503,
              data: 'recovered',
            );
          },
        ),
      ]);

      final out =
          await chain.proceedError(
                StateError('boom'),
                StackTrace.current,
                request,
              )
              as HttpResponse<String>;

      expect(out.statusCode, 503);
      expect(out.data, 'recovered');
    });

    test('rethrows when no interceptor recovers the error', () async {
      final chain = InterceptorChain([
        _TestInterceptor(
          onErr: (error, stack, req) async {
            throw error;
          },
        ),
      ]);

      expect(
        () =>
            chain.proceedError(StateError('boom'), StackTrace.current, request),
        throwsA(isA<StateError>()),
      );
    });
  });
}
