import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_resource/src/theme/app_color_extension.dart';
import 'package:flutter_resource/src/theme/app_theme.dart';
import 'package:flutter_resource/src/theme/color_tokens.dart';
import 'package:flutter_resource/src/theme/colors.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppTheme', () {
    test('light theme exposes AppColorSchemeExtension.light', () {
      final theme = AppTheme.light();
      expect(theme.brightness, Brightness.light);

      final extension = theme.extension<AppColorSchemeExtension>();
      expect(extension, isNotNull);
      expect(extension!.textMain, AppColorSchemeExtension.light.textMain);
      expect(extension.backgroundMain, AppColorSchemeExtension.light.backgroundMain);
    });

    test('dark theme exposes AppColorSchemeExtension.dark', () {
      final theme = AppTheme.dark();
      expect(theme.brightness, Brightness.dark);

      final extension = theme.extension<AppColorSchemeExtension>();
      expect(extension, isNotNull);
      expect(extension!.backgroundMain, AppColorSchemeExtension.dark.backgroundMain);
    });

    test('premier theme exposes AppColorSchemeExtension.premier', () {
      final theme = AppTheme.premier();
      expect(theme.brightness, Brightness.light);

      final extension = theme.extension<AppColorSchemeExtension>();
      expect(extension, isNotNull);
      expect(extension!.backgroundMain, AppColorSchemeExtension.premier.backgroundMain);
    });
  });

  group('ThemeTypeX', () {
    test('themeData returns corresponding theme', () {
      expect(ThemeType.light.themeData.brightness, Brightness.light);
      expect(ThemeType.dark.themeData.brightness, Brightness.dark);
      expect(ThemeType.premier.themeData.extension<AppColorSchemeExtension>()?.backgroundMain,
          AppColorSchemeExtension.premier.backgroundMain);
    });
  });

  group('AppColorSchemeExtension', () {
    test('copyWith overrides provided fields and preserves others', () {
      final base = AppColorSchemeExtension.light;
      final copy = base.copyWith(
        textMain: Colors.green,
        iconAccent: Colors.purple,
      ) as AppColorSchemeExtension;

      expect(copy.textMain, Colors.green);
      expect(copy.iconAccent, Colors.purple);
      expect(copy.textSub, base.textSub);
      expect(copy.backgroundMain, base.backgroundMain);
    });

    test('lerp blends between two schemes', () {
      final start = AppColorSchemeExtension.light;
      final end = AppColorSchemeExtension.dark;

      final lerped = start.lerp(end, 0.5) as AppColorSchemeExtension;
      final expectedTextMain = Color.lerp(start.textMain, end.textMain, 0.5)!;
      final expectedBackground = Color.lerp(start.backgroundMain, end.backgroundMain, 0.5)!;

      expect(lerped.textMain.value, expectedTextMain.value);
      expect(lerped.backgroundMain.value, expectedBackground.value);
    });
  });

  group('ColorTokens', () {
    test('brand color tokens map to AppColors', () {
      expect(ColorTokens.primaryBranding[500], AppColors.purpleBranding500);
      expect(ColorTokens.secondaryBranding[500], AppColors.orangeBranding500);
      expect(ColorTokens.positive[500], AppColors.green500);
      expect(ColorTokens.negative[500], AppColors.red500);
      expect(ColorTokens.warning[500], AppColors.yellow500);
    });
  });
}
