import 'package:flutter/material.dart';
import 'dart:io' show Platform;

/// A utility class that defines the typography styles for the application.
///
/// This class provides a set of predefined text styles that follow the application's
/// design system. It handles platform-specific font families and provides various
/// text styles for different UI elements.
///
/// Usage:
/// ```dart
/// Text('Hello', style: AppTypography.bodyM)
/// ```
class TPTextStyle {
  // Private constructor to prevent instantiation
  TPTextStyle._();

  /// Returns the platform-specific font family.
  ///
  /// Uses 'SFUIText' for iOS and 'Roboto' for other platforms.
  static String get _fontFamily {
    if (Platform.isIOS) {
      return 'SFUIText';
    }
    return 'Roboto';
  }

  /// Display small text style.
  ///
  /// Used for smaller display text elements.
  /// - Font size: 20px
  /// - Font weight: Regular (400)
  /// - Line height: 28px
  static TextStyle get displayS => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        height: 28 / 20, // line-height / font-size
        letterSpacing: 0,
      );

  /// Display medium text style.
  ///
  /// Used for medium-sized display text elements.
  /// - Font size: 20px
  /// - Font weight: Medium (500)
  /// - Line height: 28px
  static TextStyle get displayM => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        height: 28 / 20, // line-height / font-size
        letterSpacing: 0,
      );

  /// Display large text style.
  ///
  /// Used for large display text elements.
  /// - Font size: 28px
  /// - Font weight: Regular (400)
  /// - Line height: 36px
  static TextStyle get displayL => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        height: 36 / 28, // line-height / font-size
        letterSpacing: 0,
      );

  /// Label extra small text style.
  ///
  /// Used for the smallest label text.
  /// - Font size: 12px
  /// - Font weight: Regular (400)
  /// - Line height: 16px
  static TextStyle get labelXS => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        height: 16 / 12, // line-height / font-size
        letterSpacing: 0,
      );

  /// Label small text style.
  ///
  /// Used for small label text.
  /// - Font size: 14px
  /// - Font weight: Regular (400)
  /// - Line height: 20px
  static TextStyle get labelS => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        height: 20 / 14, // line-height / font-size
        letterSpacing: 0,
      );

  /// Label medium text style.
  ///
  /// Used for medium-sized label text.
  /// - Font size: 16px
  /// - Font weight: Medium (500)
  /// - Line height: 24px
  static TextStyle get labelM => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        height: 24 / 16, // line-height / font-size
        letterSpacing: 0,
      );

  /// Label large text style.
  ///
  /// Used for large label text.
  /// - Font size: 20px
  /// - Font weight: SemiBold (600)
  /// - Line height: 28px
  static TextStyle get labelL => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        height: 28 / 20, // line-height / font-size
        letterSpacing: 0,
      );

  /// Title small text style.
  ///
  /// Used for small title text.
  /// - Font size: 16px
  /// - Font weight: SemiBold (600)
  /// - Line height: 24px
  static TextStyle get titleS => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        height: 24 / 16, // line-height / font-size
        letterSpacing: 0,
      );

  /// Title medium text style.
  ///
  /// Used for medium-sized title text.
  /// - Font size: 20px
  /// - Font weight: SemiBold (600)
  /// - Line height: 28px
  static TextStyle get titleM => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        height: 28 / 20, // line-height / font-size
        letterSpacing: 0,
      );

  /// Title large text style.
  ///
  /// Used for large title text.
  /// - Font size: 28px
  /// - Font weight: Medium (500)
  /// - Line height: 36px
  static TextStyle get titleL => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        height: 36 / 28, // line-height / font-size
        letterSpacing: 0,
      );

  /// Body small text style.
  ///
  /// Used for small body text.
  /// - Font size: 14px
  /// - Font weight: Regular (400)
  /// - Line height: 20px
  static TextStyle get bodyS => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        height: 20 / 14, // line-height / font-size
        letterSpacing: 0,
      );

  /// Body medium text style.
  ///
  /// Used for medium-sized body text.
  /// - Font size: 14px
  /// - Font weight: Medium (500)
  /// - Line height: 20px
  static TextStyle get bodyM => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        height: 20 / 14, // line-height / font-size
        letterSpacing: 0,
      );

  /// Body large text style.
  ///
  /// Used for large body text.
  /// - Font size: 14px
  /// - Font weight: SemiBold (600)
  /// - Line height: 20px
  static TextStyle get bodyL => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        height: 20 / 14, // line-height / font-size
        letterSpacing: 0,
      );

  /// Body info small text style.
  ///
  /// Used for small informational body text.
  /// - Font size: 16px
  /// - Font weight: Regular (400)
  /// - Line height: 24px
  static TextStyle get bodyInfoS => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        height: 24 / 16, // line-height / font-size
        letterSpacing: 0,
      );

  /// Body info medium text style.
  ///
  /// Used for medium-sized informational body text.
  /// - Font size: 16px
  /// - Font weight: Medium (500)
  /// - Line height: 24px
  static TextStyle get bodyInfoM => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        height: 24 / 16, // line-height / font-size
        letterSpacing: 0,
      );

  /// Body info large text style.
  ///
  /// Used for large informational body text.
  /// - Font size: 16px
  /// - Font weight: SemiBold (600)
  /// - Line height: 24px
  static TextStyle get bodyInfoL => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        height: 24 / 16, // line-height / font-size
        letterSpacing: 0,
      );

  /// Caption small text style.
  ///
  /// Used for small caption text.
  /// - Font size: 12px
  /// - Font weight: Regular (400)
  /// - Line height: 16px
  static TextStyle get captionS => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        height: 16 / 12, // line-height / font-size
        letterSpacing: 0,
      );

  /// Caption medium text style.
  ///
  /// Used for medium-sized caption text.
  /// - Font size: 12px
  /// - Font weight: Medium (500)
  /// - Line height: 16px
  static TextStyle get captionM => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        height: 16 / 12, // line-height / font-size
        letterSpacing: 0,
      );

  /// Caption large text style.
  ///
  /// Used for large caption text.
  /// - Font size: 12px
  /// - Font weight: SemiBold (600)
  /// - Line height: 16px
  static TextStyle get captionL => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        height: 16 / 12, // line-height / font-size
        letterSpacing: 0,
      );

  /// Item name small text style.
  ///
  /// Used for small item name text.
  /// - Font size: 12px
  /// - Font weight: Regular (400)
  /// - Line height: 16px
  static TextStyle get itemNameS => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        height: 16 / 12, // line-height / font-size
        letterSpacing: 0,
      );

  /// Item name medium text style.
  ///
  /// Used for medium-sized item name text.
  /// - Font size: 14px
  /// - Font weight: Regular (400)
  /// - Line height: 20px
  static TextStyle get itemNameM => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        height: 20 / 14, // line-height / font-size
        letterSpacing: 0,
      );

  /// Component text style.
  ///
  /// Used for UI component text.
  /// - Font size: 10px
  /// - Font weight: Regular (400)
  /// - Line height: 12px
  static TextStyle get component => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        height: 12 / 10, // line-height / font-size
        letterSpacing: 0,
      );

  /// Returns a Flutter TextTheme using the application's typography styles.
  ///
  /// This allows the typography to be used with Flutter's theme system.
  /// Currently maps bodyM to bodyMedium, with more mappings to be added.
  static TextTheme get textTheme => TextTheme(
        // Using bodyM as bodyMedium in Flutter's TextTheme
        bodyMedium: bodyM,
        // Other styles will be added as per design system
      );
}

/// Extension for adding text decoration styles to TextStyle.
///
/// This extension provides methods to add underline and strikethrough
/// decorations to any TextStyle.
///
/// Usage:
/// ```dart
/// Text('Underlined text', style: AppTypography.bodyM.underlined)
/// Text('Strikethrough text', style: AppTypography.captionM.strikethrough)
/// ```
extension TextStyleDecorationExtension on TextStyle {
  /// Adds underline decoration to the text style.
  ///
  /// Returns a new TextStyle with underline decoration applied.
  TextStyle get underlined => copyWith(
        decoration: TextDecoration.underline,
        decorationStyle: TextDecorationStyle.solid,
        decorationThickness: 1.0,
      );

  /// Adds strikethrough decoration to the text style.
  ///
  /// Returns a new TextStyle with strikethrough decoration applied.
  TextStyle get strikethrough => copyWith(
        decoration: TextDecoration.lineThrough,
        decorationStyle: TextDecorationStyle.solid,
        decorationThickness: 1.0,
      );
}