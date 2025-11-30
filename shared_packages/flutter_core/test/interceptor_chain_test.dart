import 'package:flutter_core/src/data/network/http_request.dart';
import 'package:flutter_core/src/data/network/http_response.dart';
import 'package:flutter_core/src/data/network/interceptor/interceptor_chain.dart';
import 'package:flutter_core/src/data/network/interceptor/http_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestInterceptor extends HttpInterceptor {
  _TestInterceptor({this.onRequestCallback, this.onResponseCallback, this.onErrorCallback});

  final Future<HttpRequest> Function(HttpRequest request)? onRequestCallback;
  final Future<HttpResponse> Function(HttpResponse response)? onResponseCallback;
  final Future<HttpResponse> Function(Object error, StackTrace stack, HttpRequest request)?
      onErrorCallback;

  @override
  Future<HttpRequest> onRequest(HttpRequest request) async {
    if (onRequestCallback != null) {
      return onRequestCallback!(request);
    }
    return super.onRequest(request);
  }

  @override
  Future<HttpResponse> onResponse(HttpResponse response) async {
    if (onResponseCallback != null) {
      return onResponseCallback!(response);
    }
    return super.onResponse(response);
  }

  @override
  Future<HttpResponse> onError(Object error, StackTrace stack, HttpRequest request) async {
    if (onErrorCallback != null) {
      return onErrorCallback!(error, stack, request);
    }
    return super.onError(error, stack, request);
  }
}

void main() {
  final request = HttpRequest(method: 'GET', url: Uri.parse('https://example.com'));
  final response = HttpResponse(request: request, statusCode: 200);

  test('proceedRequest runs interceptors in declaration order', () async {
    final calls = <String>[];
    final chain = InterceptorChain([
      _TestInterceptor(onRequestCallback: (r) async {
        calls.add('first');
        return r.copyWith(headers: {...r.headers, 'trace': '1'});
      }),
      _TestInterceptor(onRequestCallback: (r) async {
        calls.add('second');
        return r.copyWith(headers: {...r.headers, 'trace': '${r.headers['trace']},2'});
      }),
    ]);

    final out = await chain.proceedRequest(request);
    expect(calls, ['first', 'second']);
    expect(out.headers['trace'], '1,2');
  });

  test('proceedResponse runs interceptors in reverse order', () async {
    final calls = <String>[];
    final chain = InterceptorChain([
      _TestInterceptor(onResponseCallback: (res) async {
        calls.add('first');
        return res;
      }),
      _TestInterceptor(onResponseCallback: (res) async {
        calls.add('second');
        return res;
      }),
    ]);

    await chain.proceedResponse(response);
    expect(calls, ['second', 'first']);
  });

  test('proceedError allows interceptors to recover', () async {
    final chain = InterceptorChain([
      _TestInterceptor(onErrorCallback: (_, _, _) async {
        fail('Earlier interceptors should not be reached once recovered');
      }),
      _TestInterceptor(onErrorCallback: (error, stack, req) async {
        return HttpResponse(request: req, statusCode: 418, data: 'teapot');
      }),
    ]);

    final out = await chain.proceedError(Exception('boom'), StackTrace.current, request);
    expect(out.statusCode, 418);
    expect(out.data, 'teapot');
  });
}
