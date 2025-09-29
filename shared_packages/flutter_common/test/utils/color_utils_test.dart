import 'package:flutter/material.dart';
import 'package:flutter_common/src/utils/color_utils.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HexColorExtension', () {
    test('returns a color when provided a 6 digit hex string', () {
      final color = '#112233'.toColor();

      expect(color, isNotNull);
      expect(color, const Color(0xFF112233));
    });

    test('returns a color when provided an 8 digit hex string', () {
      final color = 'AA0011FF'.toColor();

      expect(color, isNotNull);
      expect(color, const Color(0xAA0011FF));
    });

    test('returns null when the string length is invalid', () {
      expect('12345'.toColor(), isNull);
      expect('123456789'.toColor(), isNull);
    });

    test('returns null when the string cannot be parsed', () {
      expect('#ZZ1122'.toColor(), isNull);
    });
  });

  group('TPThemeColors', () {
    test('exposes the registered AppColorSchemeExtension', () {
      final appColors = createAppColorSchemeExtension(color: Colors.purple);
      final theme = ThemeData(extensions: <ThemeExtension<dynamic>>[appColors]);

      expect(theme.appColors, isNotNull);
      expect(theme.appColors?.textMain, Colors.purple);
    });

    test('returns null when the extension is not registered', () {
      final theme = ThemeData();

      expect(theme.appColors, isNull);
    });
  });
}
