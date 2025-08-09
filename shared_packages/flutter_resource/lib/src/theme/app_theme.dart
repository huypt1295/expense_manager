import 'package:flutter/material.dart';
import 'app_color_extension.dart';

enum ThemeType { light, dark, premier }

/// Factory for creating app themes
class AppTheme {
  AppTheme._();

  /// Creates the light theme for the app
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      extensions: [AppColorSchemeExtension.light],
      brightness: Brightness.light,
    );
  }

  /// Creates the dark theme for the app
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      extensions: [AppColorSchemeExtension.dark],
      brightness: Brightness.dark,
    );
  }

  /// Creates the premier theme for the app
  static ThemeData premier() {
    return ThemeData(
      useMaterial3: true,
      extensions: [AppColorSchemeExtension.premier],
      brightness: Brightness.light
    );
  }
}

extension ThemeTypeX on ThemeType {
  // Helper method to get the appropriate theme based on theme type
  ThemeData get themeData {
    switch (this) {
      case ThemeType.light:
        return AppTheme.light();
      case ThemeType.dark:
        return AppTheme.dark();
      case ThemeType.premier:
        return AppTheme.premier();
      default:
        return AppTheme.light();
    }
  }
}
