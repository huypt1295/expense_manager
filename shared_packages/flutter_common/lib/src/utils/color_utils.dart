import 'package:flutter/material.dart';
import 'package:flutter_resource/flutter_resource.dart';

/// Extension to access theme colors directly from ThemeData
extension TPThemeColors on ThemeData {
  /// Get the app color scheme extension
  AppColorSchemeExtension? get appColors =>
      extension<AppColorSchemeExtension>();
}

extension HexColorExtension on String {
  Color? toColor() {
    // Remove the '#' if present and normalize the string
    String hexColor = replaceAll('#', '');

    // Ensure the hex string is valid (6 or 8 characters)
    if (hexColor.length != 6 && hexColor.length != 8) {
      return null;
    }

    // Add default alpha (FF) if only RGB is provided
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }

    // Parse the hex string to an integer and create a Color
    try {
      return Color(int.parse('0x$hexColor'));
    } catch (e) {
      return null;
    }
  }
}
