import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:intl/intl.dart';

/// Exposes locale data via the `intl` package and notifies listeners on change.
class LocaleServiceImpl extends LocaleService with ChangeNotifier {
  /// Retrieves the current locale reported by the `intl` package.
  @override
  Locale get currentLocale => Locale(Intl.getCurrentLocale());

  /// Resolves a localized string for the given [key] and [langCode].
  @override
  String getStringLocalization(String key, String langCode) =>
      Intl.message(key, locale: langCode);
}
