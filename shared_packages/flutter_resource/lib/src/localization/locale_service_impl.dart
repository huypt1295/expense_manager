import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:intl/intl.dart';

class LocaleServiceImpl extends LocaleService with ChangeNotifier {
  @override
  Locale get currentLocale => Locale(Intl.getCurrentLocale());

  @override
  String getStringLocalization(String key, String langCode) =>
      Intl.message(key, locale: langCode);
}
