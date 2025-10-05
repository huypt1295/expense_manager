import 'package:flutter/services.dart';
import 'package:flutter_common/src/utils/vnd_currency_input_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VndCurrencyInputFormatter', () {
    const formatter = VndCurrencyInputFormatter();

    test('formats digits with thousand separators and suffix', () {
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '1234567');

      final formatted = formatter.formatEditUpdate(oldValue, newValue);

      expect(formatted.text, '1,234,567 VND');
      expect(formatted.selection.baseOffset, formatted.text.length);
    });

    test('returns empty value when no digits remain', () {
      const oldValue = TextEditingValue(text: '1,000 VND');
      const newValue = TextEditingValue(text: '');

      final formatted = formatter.formatEditUpdate(oldValue, newValue);

      expect(formatted.text, isEmpty);
      expect(formatted.selection.baseOffset, 0);
    });

    test('strips non-digit characters before formatting', () {
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: 'ab12c3');

      final formatted = formatter.formatEditUpdate(oldValue, newValue);

      expect(formatted.text, '123 VND');
    });

    test('omits suffix when requested', () {
      const localFormatter = VndCurrencyInputFormatter(includeSuffix: false);
      const formatted = TextEditingValue(text: '7890');

      final result = localFormatter.formatEditUpdate(
        TextEditingValue.empty,
        formatted,
      );

      expect(result.text, '7,890');
    });
  });
}
