import 'package:flutter_common/src/utils/regex_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RegexExtension.isValidUrl', () {
    test('returns true for http and https urls', () {
      expect('https://example.com'.isValidUrl(), isTrue);
      expect('http://example.com'.isValidUrl(), isTrue);
    });

    test('returns false for invalid urls', () {
      expect('ftp://example.com'.isValidUrl(), isFalse);
      expect('not a url'.isValidUrl(), isFalse);
      expect((null as String?).isValidUrl(), isFalse);
    });
  });
}
