import 'package:flutter_common/src/utils/currency_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CurrencyUtils.formatVnd', () {
    test('formats standard positive amounts with commas', () {
      expect(CurrencyUtils.formatVnd('1000'), '1,000 VND');
      expect(CurrencyUtils.formatVnd('60000'), '60,000 VND');
      expect(CurrencyUtils.formatVnd('700000'), '700,000 VND');
      expect(CurrencyUtils.formatVnd('8000000'), '8,000,000 VND');
    });

    test('trims input and preserves negative sign for non-zero values', () {
      expect(CurrencyUtils.formatVnd(' -9876543 '), '-9,876,543 VND');
    });

    test('drops leading zeros in the final output', () {
      expect(CurrencyUtils.formatVnd('000123456'), '123,456 VND');
    });

    test('returns zero when input has no digits', () {
      expect(CurrencyUtils.formatVnd(''), '0 VND');
      expect(CurrencyUtils.formatVnd('abc'), '0 VND');
    });

    test('supports disabling the suffix', () {
      expect(CurrencyUtils.formatVnd('1000', includeSuffix: false), '1,000');
    });

    test('handles very large numbers without overflow', () {
      expect(
        CurrencyUtils.formatVnd('12345678901234567890'),
        '12,345,678,901,234,567,890 VND',
      );
    });
  });

  group('CurrencyUtils.parseVndToDouble', () {
    test('parses formatted text into raw numeric double', () {
      expect(CurrencyUtils.parseVndToDouble('1,234 VND'), 1234);
      expect(CurrencyUtils.parseVndToDouble('60,000 VND'), 60000);
    });

    test('returns null when no digits are present', () {
      expect(CurrencyUtils.parseVndToDouble(''), isNull);
      expect(CurrencyUtils.parseVndToDouble('abc'), isNull);
    });

    test('ignores any non-digit characters', () {
      expect(CurrencyUtils.parseVndToDouble('  VND 1,000'), 1000);
      expect(CurrencyUtils.parseVndToDouble('-9,876 VND'), 9876);
    });
  });
}
