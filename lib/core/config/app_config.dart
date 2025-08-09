import 'package:flutter_resource/flutter_resource.dart';

class AppConfig {
  final ThemeType themeType;
  final String localize;

  AppConfig({
    required this.themeType,
    required this.localize,
  });

  AppConfig copyWith({
    ThemeType? themeType,
    String? localize,
    String? baseURL,
    String? routeName,
    String? selectedAccountNo,
  }) {
    return AppConfig(
      themeType: themeType ?? this.themeType,
      localize: localize ?? this.localize,
    );
  }

  static AppConfig initialConfig() {
    return AppConfig(
      themeType: ThemeType.light,
      localize: 'vi',
    );
  }
}
