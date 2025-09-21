import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

class AppConfig extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;

  const AppConfig({
    required this.themeMode,
    required this.locale,
  });

  factory AppConfig.initial() {
    return const AppConfig(
      locale: Locale('vi'),
      themeMode: ThemeMode.light,
    );
  }

  AppConfig copyWith({
    ThemeMode? themeMode,
    Locale? locale,
  }) {
    return AppConfig(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [themeMode, locale];
}

extension ThemeModeX on ThemeMode {
  bool get isDarkMode => this == ThemeMode.dark;
}
