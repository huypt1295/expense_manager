import 'package:flutter/material.dart';
import 'app_color_extension.dart';

/// Supported visual themes for the application.
enum ThemeType { light, dark, premier }

/// Factory for creating the Material theme configurations used by the app.
class AppTheme {
  AppTheme._();

  /// Builds the light theme configuration.
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      extensions: [AppColorSchemeExtension.light],
      brightness: Brightness.light,
    );
  }

  /// Builds the dark theme configuration.
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      extensions: [AppColorSchemeExtension.dark],
      brightness: Brightness.dark,
    );
  }

  /// Builds the premier theme configuration.
  static ThemeData premier() {
    return ThemeData(
      useMaterial3: true,
      extensions: [AppColorSchemeExtension.premier],
      brightness: Brightness.light,
    );
  }
}

/// Convenience helpers for converting a [ThemeType] into usable data.
extension ThemeTypeX on ThemeType {
  /// Returns the [ThemeData] associated with this theme type.
  ThemeData get themeData {
    switch (this) {
      case ThemeType.light:
        return AppTheme.light();
      case ThemeType.dark:
        return AppTheme.dark();
      case ThemeType.premier:
        return AppTheme.premier();
      }
  }
}
