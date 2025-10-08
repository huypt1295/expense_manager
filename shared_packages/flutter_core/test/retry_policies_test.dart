import 'package:dio/dio.dart';
import 'package:flutter_core/src/data/network/retry_policies.dart';
import 'package:flutter_test/flutter_test.dart';

DioException _dioException(DioExceptionType type, {Response<dynamic>? response}) {
  if (type == DioExceptionType.badCertificate) {
    return DioException.badCertificate(
      requestOptions: RequestOptions(path: '/'),
    );
  }
  return DioException(
    type: type,
    requestOptions: RequestOptions(path: '/'),
    response: response,
  );
}

void main() {
  test('ExponentialBackoff increases delay exponentially and caps at max', () {
    const backoff = ExponentialBackoff(
      maxRetries: 5,
      base: Duration(milliseconds: 200),
      max: Duration(milliseconds: 500),
      jitter: 0,
    );

    expect(backoff.delay(1), const Duration(milliseconds: 200));
    expect(backoff.delay(2), const Duration(milliseconds: 400));
    expect(backoff.delay(3), const Duration(milliseconds: 500));
    expect(backoff.delay(4), const Duration(milliseconds: 500));
  });

  group('dioShouldRetry', () {
    test('retries on timeout and connection errors', () {
      expect(dioShouldRetry(_dioException(DioExceptionType.connectionTimeout), 1), isTrue);
      expect(dioShouldRetry(_dioException(DioExceptionType.receiveTimeout), 1), isTrue);
      expect(dioShouldRetry(_dioException(DioExceptionType.connectionError), 1), isTrue);
    });

    test('retries on 5xx and 429 responses', () {
      final response = Response(
        requestOptions: RequestOptions(path: '/'),
        statusCode: 500,
      );
      expect(
        dioShouldRetry(_dioException(DioExceptionType.badResponse, response: response), 1),
        isTrue,
      );

      final rateLimited = Response(
        requestOptions: RequestOptions(path: '/'),
        statusCode: 429,
      );
      expect(
        dioShouldRetry(_dioException(DioExceptionType.badResponse, response: rateLimited), 1),
        isTrue,
      );
    });

    test('retries on bad certificate errors', () {
      expect(dioShouldRetry(_dioException(DioExceptionType.badCertificate), 1), isTrue);
    });
  });
}
