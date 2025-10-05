import 'package:flutter/services.dart';

import 'currency_utils.dart';

/// Formats numeric input into a human-readable VND currency string.
class VndCurrencyInputFormatter extends TextInputFormatter {
  const VndCurrencyInputFormatter({this.includeSuffix = true});

  final bool includeSuffix;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = CurrencyUtils.digitsOnly(newValue.text);

    if (digits.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    final formatted = CurrencyUtils.formatVnd(
      digits,
      includeSuffix: includeSuffix,
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
