import 'package:flutter/material.dart';

abstract class LocaleService {
  Locale get currentLocale;
  String getStringLocalization(String key, String langCode);
}
