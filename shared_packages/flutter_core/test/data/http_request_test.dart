import 'package:flutter_core/src/data/network/http_request.dart';
import 'package:flutter_core/src/data/network/http_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HttpRequest', () {
    test('copyWith overrides provided fields and keeps others', () {
      final original = HttpRequest(
        method: 'GET',
        url: Uri.parse('https://example.com/path'),
        headers: const {'Authorization': 'token'},
        body: const {'a': 1},
        timeout: const Duration(seconds: 5),
        queryParameters: const {'page': 1},
        retryOverride: true,
        cancelToken: Object(),
      );

      final updated = original.copyWith(
        method: 'POST',
        headers: const {'Authorization': 'other'},
        body: const {'b': 2},
      );

      expect(updated.method, 'POST');
      expect(updated.url, original.url);
      expect(updated.headers, {'Authorization': 'other'});
      expect(updated.body, {'b': 2});
      expect(updated.timeout, original.timeout);
      expect(updated.queryParameters, original.queryParameters);
      expect(updated.retryOverride, original.retryOverride);
      expect(updated.cancelToken, original.cancelToken);
    });
  });

  group('HttpResponse', () {
    test('isSuccessful returns true for 2xx codes', () {
      final res = HttpResponse<String>(
        request: HttpRequest(
          method: 'GET',
          url: Uri.parse('https://example.com'),
        ),
        statusCode: 204,
      );

      expect(res.isSuccessful, isTrue);
    });

    test('isSuccessful returns false outside 2xx range', () {
      final res = HttpResponse<String>(
        request: HttpRequest(
          method: 'GET',
          url: Uri.parse('https://example.com'),
        ),
        statusCode: 404,
      );

      expect(res.isSuccessful, isFalse);
    });
  });
}
