import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_resource/src/theme/typography.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TPTextStyle', () {
    final expectedFontFamily = Platform.isIOS ? 'SFUIText' : 'Roboto';

    test('displayS uses expected typography values', () {
      final style = TPTextStyle.displayS;
      expect(style.fontFamily, expectedFontFamily);
      expect(style.fontSize, 20);
      expect(style.fontWeight, FontWeight.w400);
      expect(style.height, closeTo(28 / 20, 0.0001));
    });

    test('labelM uses medium weight with consistent metrics', () {
      final style = TPTextStyle.labelM;
      expect(style.fontFamily, expectedFontFamily);
      expect(style.fontSize, 16);
      expect(style.fontWeight, FontWeight.w500);
      expect(style.height, closeTo(24 / 16, 0.0001));
    });

    test('textTheme maps bodyMedium to bodyM style values', () {
      final style = TPTextStyle.textTheme.bodyMedium;
      expect(style, isNotNull);
      expect(style!.fontSize, TPTextStyle.bodyM.fontSize);
      expect(style.fontWeight, TPTextStyle.bodyM.fontWeight);
      expect(style.height, TPTextStyle.bodyM.height);
    });
  });

  group('TextStyleDecorationExtension', () {
    test('underlined adds underline decoration', () {
      final style = TPTextStyle.bodyM.underlined;
      expect(style.decoration, TextDecoration.underline);
      expect(style.decorationStyle, TextDecorationStyle.solid);
      expect(style.decorationThickness, 1.0);
    });

    test('strikethrough adds lineThrough decoration', () {
      final style = TPTextStyle.bodyM.strikethrough;
      expect(style.decoration, TextDecoration.lineThrough);
      expect(style.decorationStyle, TextDecorationStyle.solid);
      expect(style.decorationThickness, 1.0);
    });
  });
}
