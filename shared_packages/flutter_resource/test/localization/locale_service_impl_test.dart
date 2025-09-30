import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_resource/flutter_resource.dart';
import 'package:flutter_resource/src/localization/locale_service_impl.dart';
import 'package:intl/intl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocaleServiceImpl', () {
    late LocaleServiceImpl service;

    setUp(() {
      service = LocaleServiceImpl();
    });

    test('currentLocale reflects Intl current locale', () {
      Intl.defaultLocale = 'vi';
      expect(service.currentLocale, const Locale('vi'));
    });

    test('getStringLocalization delegates through Intl.message', () {
      Intl.defaultLocale = 'en';
      final result = service.getStringLocalization('greeting', 'vi');
      expect(result, 'greeting');
    });
  });

  group('LocaleConstants', () {
    test('exposes known locale identifiers', () {
      expect(LocaleConstants.en, 'en');
      expect(LocaleConstants.vi, 'vi');
      expect(LocaleConstants.defaultLocale, LocaleConstants.vi);
    });
  });

  group('L10n', () {
    test('supportedLocales matches expected locales', () {
      expect(L10n.supportedLocales, const [Locale('en'), Locale('vi')]);
    });

    test('localizationsDelegates exposes generated delegate', () {
      expect(L10n.localizationsDelegates, contains(S.delegate));
    });
  });
}
