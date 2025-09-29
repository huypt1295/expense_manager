import 'package:flutter_common/src/utils/string_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StringExtensions.plus', () {
    test('concatenates two strings', () {
      expect('Hello '.plus('World'), 'Hello World');
    });
  });

  group('StringExtensions.equalsIgnoreCase', () {
    test('performs case-insensitive contains check', () {
      expect('Flutter'.equalsIgnoreCase('flut'), isTrue);
      expect('Flutter'.equalsIgnoreCase('FLUTTER'), isTrue);
      expect('Flutter'.equalsIgnoreCase('dart'), isFalse);
    });
  });
}
