import 'package:flutter/material.dart';
import 'package:flutter_resource/l10n/gen/l10n.dart';

class L10n {
  static S of(BuildContext context) {
    return S.of(context);
  }

  static S get current {
    return S.current;
  }

  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('vi'), // Vietnamese
  ];

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    S.delegate,
  ];
}
