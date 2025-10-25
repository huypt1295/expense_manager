import 'package:flutter/material.dart';

extension ThemeModeX on ThemeMode {
  IconData get icon {
    switch (this) {
      case ThemeMode.dark:
        return Icons.dark_mode_outlined;
      case ThemeMode.light:
        return Icons.light_mode_outlined;
      case ThemeMode.system:
        return Icons.settings_outlined;
    }
  }
}
