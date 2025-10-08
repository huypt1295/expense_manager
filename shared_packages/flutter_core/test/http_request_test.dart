import 'package:flutter_core/src/data/network/http_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('copyWith overrides provided fields', () {
    final original = HttpRequest(
      method: 'GET',
      url: Uri.parse('https://example.com'),
      headers: const {'A': '1'},
      body: 'body',
      timeout: const Duration(seconds: 5),
      queryParameters: const {'page': 1},
      retryOverride: true,
      cancelToken: 'token',
    );

    final copy = original.copyWith(
      method: 'POST',
      headers: const {'B': '2'},
      body: {'k': 'v'},
      timeout: const Duration(seconds: 1),
      queryParameters: const {'page': 2},
      retryOverride: false,
      cancelToken: 'new',
    );

    expect(copy.method, 'POST');
    expect(copy.headers, {'B': '2'});
    expect(copy.body, {'k': 'v'});
    expect(copy.timeout, const Duration(seconds: 1));
    expect(copy.queryParameters, {'page': 2});
    expect(copy.retryOverride, isFalse);
    expect(copy.cancelToken, 'new');
    expect(copy.url, original.url);
  });
}
