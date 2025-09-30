import 'package:dio/dio.dart';
import 'package:flutter_core/src/data/network/retry_policies.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExponentialBackoff', () {
    test('doubles delay per attempt without jitter', () {
      const backoff = ExponentialBackoff(
        base: Duration(milliseconds: 100),
        maxRetries: 4,
        jitter: 0,
      );

      expect(backoff.delay(1), const Duration(milliseconds: 100));
      expect(backoff.delay(2), const Duration(milliseconds: 200));
      expect(backoff.delay(3), const Duration(milliseconds: 400));
    });

    test('caps delay at max when provided', () {
      const backoff = ExponentialBackoff(
        base: Duration(milliseconds: 150),
        max: Duration(milliseconds: 300),
        jitter: 0,
      );

      expect(backoff.delay(1), const Duration(milliseconds: 150));
      expect(backoff.delay(2), const Duration(milliseconds: 300));
      expect(backoff.delay(3), const Duration(milliseconds: 300));
    });
  });

  group('dioShouldRetry', () {
    DioException _exception(DioExceptionType type, {int? status}) =>
        DioException(
          requestOptions: RequestOptions(path: '/'),
          type: type,
          response: status == null
              ? null
              : Response(
                  requestOptions: RequestOptions(path: '/'),
                  statusCode: status,
                ),
        );

    test('retries for timeout related errors', () {
      expect(
        dioShouldRetry(_exception(DioExceptionType.connectionTimeout), 1),
        isTrue,
      );
      expect(
        dioShouldRetry(_exception(DioExceptionType.sendTimeout), 1),
        isTrue,
      );
      expect(
        dioShouldRetry(_exception(DioExceptionType.receiveTimeout), 1),
        isTrue,
      );
    });

    test('retries for retriable status codes', () {
      expect(
        dioShouldRetry(
          _exception(DioExceptionType.badResponse, status: 503),
          1,
        ),
        isTrue,
      );
      expect(
        dioShouldRetry(
          _exception(DioExceptionType.badResponse, status: 429),
          1,
        ),
        isTrue,
      );
      expect(
        dioShouldRetry(
          _exception(DioExceptionType.badResponse, status: 408),
          1,
        ),
        isTrue,
      );
    });

    test('does not retry for non-retriable responses', () {
      expect(
        dioShouldRetry(
          _exception(DioExceptionType.badResponse, status: 403),
          1,
        ),
        isFalse,
      );
    });

    test('returns false for non-Dio errors', () {
      expect(dioShouldRetry(ArgumentError('boom'), 1), isFalse);
    });
  });
}
