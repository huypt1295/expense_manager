import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'app_config.dart';

class ConfigCubit extends Cubit<AppConfig> {
  ConfigCubit() : super(AppConfig.initial()) {
    _initConfig();
  }

  Future<void> _initConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('config_language') ??
        AppConfig.initial().locale.languageCode;
    final isDarkMode = prefs.getBool('config_dark_mode') ??
        AppConfig.initial().themeMode.isDarkMode;

    final locale = Locale(languageCode);
    final themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
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
    await prefs.setBool('config_dark_mode', themeMode == ThemeMode.dark);

    emit(state.copyWith(themeMode: themeMode));
  }
}
