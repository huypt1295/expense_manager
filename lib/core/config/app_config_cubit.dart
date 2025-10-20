import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'app_config.dart';

class ConfigCubit extends Cubit<AppConfig> {
  ConfigCubit() : super(AppConfig.initial()) {
    _initConfig();
  }

  Future<void> _initConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode =
        prefs.getString('config_language') ??
        AppConfig.initial().locale.languageCode;
    final storedTheme = prefs.getString('config_theme_mode');
    final isDarkModeLegacy = prefs.getBool('config_dark_mode');

    final locale = Locale(languageCode);
    final themeMode = storedTheme != null
        ? _decodeThemeMode(storedTheme)
        : (isDarkModeLegacy == null
              ? AppConfig.initial().themeMode
              : (isDarkModeLegacy ? ThemeMode.dark : ThemeMode.light));
    emit(AppConfig(locale: locale, themeMode: themeMode));
  }

  Future<void> changeLanguage({required String languageCode}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('config_language', languageCode);

    final newLocale = Locale(languageCode);
    emit(state.copyWith(locale: newLocale));
  }

  Future<void> toggleTheme({required ThemeMode themeMode}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('config_theme_mode', _encodeThemeMode(themeMode));
    await prefs.remove('config_dark_mode');

    emit(state.copyWith(themeMode: themeMode));
  }

  String _encodeThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
    }
  }

  ThemeMode _decodeThemeMode(String value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }
}
