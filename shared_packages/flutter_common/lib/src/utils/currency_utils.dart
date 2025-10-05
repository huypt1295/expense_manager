/// Helpers for formatting currency values into human-readable strings.
class CurrencyUtils {
  static const String _currencySuffix = ' VND';

  /// Formats a numeric string [amount] into a VND currency representation.
  ///
  /// Non-digit characters are ignored and the result is suffixed with `VND`
  /// unless [includeSuffix] is `false`.
    static String formatVnd(String amount, {bool includeSuffix = true}) {
    final trimmed = amount.trim();
    if (trimmed.isEmpty) {
      return _resultWithSuffix('0', includeSuffix);
    }

    final isNegative = trimmed.startsWith('-');
    final numericDigits = digitsOnly(trimmed);
    if (numericDigits.isEmpty) {
      return _resultWithSuffix('0', includeSuffix);
    }

    final numericValue = BigInt.parse(numericDigits);
    final digits = numericValue.toString();
    final groups = <String>[];
    for (var i = digits.length; i > 0; i -= 3) {
      final start = i - 3;
      groups.add(digits.substring(start < 0 ? 0 : start, i));
    }

    final groupedDigits = groups.reversed.join(',');
    final sign = isNegative && numericValue != BigInt.zero ? '-' : '';

    return _resultWithSuffix('$sign$groupedDigits', includeSuffix);
  }

  /// Formats a double [amount] into a VND currency representation.
  ///
  /// The value is rounded to the nearest whole number before formatting.
  /// When [amount] is `NaN` or infinite, `0` is returned.
  static String formatVndFromDouble(double amount, {bool includeSuffix = true}) {
    if (amount.isNaN || amount.isInfinite) {
      return _resultWithSuffix('0', includeSuffix);
    }

    final roundedAmount = amount.round();
    return formatVnd(roundedAmount.toString(), includeSuffix: includeSuffix);
  }

  /// Returns only the digits contained in [amount].
  static String digitsOnly(String amount) {
    return amount.replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// Attempts to parse the provided [amount] string into a double by discarding
  /// all non-digit characters. Returns `null` when the input has no digits.
  static double? parseVndToDouble(String amount) {
    final digits = digitsOnly(amount);
    if (digits.isEmpty) {
      return null;
    }

    return double.tryParse(digits);
  }

  static String _resultWithSuffix(String value, bool includeSuffix) {
    return includeSuffix ? '$value$_currencySuffix' : value;
  }
}
