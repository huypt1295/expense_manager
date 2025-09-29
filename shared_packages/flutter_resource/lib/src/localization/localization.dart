import 'package:flutter/material.dart';
import 'package:flutter_resource/l10n/gen/l10n.dart';

/// Provides convenient access to the generated localization resources.
class L10n {
  /// Returns the [S] localization instance for the provided [context].
  static S of(BuildContext context) {
    return S.of(context);
  }

  /// Returns the current [S] localization instance without requiring context.
  static S get current {
    return S.current;
  }

  /// List of locales supported by the application.
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('vi'), // Vietnamese
  ];

  /// Delegates required for providing localized resources to the app.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    S.delegate,
  ];
}
