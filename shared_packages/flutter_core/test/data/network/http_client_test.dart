import 'package:dio/dio.dart';
import 'package:flutter_core/src/data/network/http_client.dart';
import 'package:flutter_core/src/data/network/http_request.dart';
import 'package:flutter_core/src/data/network/http_response.dart';
import 'package:flutter_core/src/data/network/interceptor/http_interceptor.dart';
import 'package:flutter_core/src/data/network/retry_policies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

class _RecordingInterceptor extends HttpInterceptor {
  int requestCount = 0;
  int responseCount = 0;

  @override
  Future<HttpRequest> onRequest(HttpRequest request) async {
    requestCount += 1;
    return request.copyWith(headers: {...request.headers, 'x-intercepted': 'true'});
  }

  @override
  Future<HttpResponse> onResponse(HttpResponse response) async {
    responseCount += 1;
    return response;
  }
}

class _RecoveringInterceptor extends HttpInterceptor {
  final HttpResponse response;
  _RecoveringInterceptor(this.response);

  @override
  Future<HttpResponse> onError(Object error, StackTrace stack, HttpRequest request) async {
    return response;
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: '/'));
    registerFallbackValue(Options());
    registerFallbackValue(<String, dynamic>{});
  });

  test('DioHttpClient sends request through interceptors and returns typed data', () async {
    final dio = _MockDio();
    when(() => dio.options).thenReturn(BaseOptions());
    final interceptor = _RecordingInterceptor();
    final client = DioHttpClient(dio, [interceptor]);

    Options? capturedOptions;
    when(() => dio.request<Object?>(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((invocation) async {
      capturedOptions = invocation.namedArguments[#options] as Options?;
      return Response(
        requestOptions: RequestOptions(path: '/endpoint'),
        statusCode: 200,
        data: {'value': 1},
        headers: Headers.fromMap({'content-type': ['application/json']}),
      );
    });

    final request = HttpRequest(
      method: 'POST',
      url: Uri.parse('https://example.com/endpoint'),
      body: {'foo': 'bar'},
      headers: const {'Accept': 'json'},
    );

    final response = await client.send<Map<String, dynamic>>(request);

    expect(response.statusCode, 200);
    expect(response.data, {'value': 1});
    expect(response.headers['content-type'], 'application/json');
    expect(interceptor.requestCount, 1);
    expect(interceptor.responseCount, 1);

    verify(() => dio.request<Object?>(
          'https://example.com/endpoint',
          data: request.body,
          queryParameters: request.queryParameters,
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).called(1);
    expect(capturedOptions, isNotNull);
    expect(capturedOptions!.method, 'POST');
    expect(capturedOptions!.headers!['x-intercepted'], 'true');
  });

  test('DioHttpClient retries transient responses using retry policy', () async {
    final dio = _MockDio();
    when(() => dio.options).thenReturn(BaseOptions());
    final responses = <Response<Object?>>[
      Response(requestOptions: RequestOptions(path: '/retry'), statusCode: 500),
      Response(requestOptions: RequestOptions(path: '/retry'), statusCode: 200, data: 'ok'),
    ];
    var callCount = 0;

    when(() => dio.request<Object?>(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => responses[callCount++]);

    final policy = RetryPolicy(
      shouldRetry: (error, attempt) => true,
      backoff: const ExponentialBackoff(base: Duration.zero, jitter: 0, maxRetries: 3),
    );

    final client = DioHttpClient(dio, [], policy: policy);
    final request = HttpRequest(method: 'GET', url: Uri.parse('https://retry.com'));

    final response = await client.send<String>(request);

    expect(response.statusCode, 200);
    expect(response.data, 'ok');
    expect(callCount, 2);
  });

  test('DioHttpClient allows interceptor to recover from errors', () async {
    final dio = _MockDio();
    when(() => dio.options).thenReturn(BaseOptions());
    when(() => dio.request<Object?>(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenThrow(Exception('network'));

    final recovered = HttpResponse<String>(
      request: HttpRequest(method: 'GET', url: Uri.parse('https://fallback')),
      statusCode: 418,
      data: 'fallback',
    );

    final client = DioHttpClient(
      dio,
      [_RecoveringInterceptor(recovered)],
      policy: RetryPolicy(shouldRetry: (_, __) => false, backoff: const ExponentialBackoff(maxRetries: 1)),
    );

    final response = await client.send<String>(
      HttpRequest(method: 'GET', url: Uri.parse('https://example.com')),
    );

    expect(response.statusCode, 418);
    expect(response.data, 'fallback');
  });
}
