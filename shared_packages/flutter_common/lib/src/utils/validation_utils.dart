/// Helper methods for validating common text input patterns.
class ValidationUtils {
  const ValidationUtils._();

  /// Returns `true` when [password] satisfies the minimum requirements.
  static bool isValidPassword(String password) {
    return password.isNotEmpty;
  }

  /// Returns `true` when [phoneNumber] is not empty.
  static bool isEmptyPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      return false;
    }

    return true;
  }

  /// Validates that [phoneNumber] matches a 10-11 digit pattern.
  static bool isValidPhoneNumber(String phoneNumber) {
    if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,11}$)').hasMatch(phoneNumber.trim())) {
      return false;
    }

    return true;
  }

  /// Returns `true` when [email] is not empty.
  static bool isEmptyEmail(String email) {
    if (email.isEmpty) {
      return false;
    }

    return true;
  }

  /// Validates [email] using a basic email regular expression.
  static bool isValidEmail(String email) {
    if (!RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$').hasMatch(email.trim())) {
      return false;
    }

    return true;
  }

  /// Returns `true` when [dateTime] is not empty.
  static bool isEmptyDateTime(String dateTime) {
    if (dateTime.isEmpty) {
      return false;
    }

    return true;
  }

  /// Validates [dateTime] against the supported DD/MM/YYYY style patterns.
  static bool isValidDateTime(String dateTime) {
    if (!RegExp(
      r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$',
    ).hasMatch(dateTime)) {
      return false;
    }

    return true;
  }

  /// Returns `true` when [text] contains only alpha-numeric characters.
  static bool isAlphanumeric(String text) {
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(text.trim())) {
      return false;
    }

    return true;
  }

  /// Returns `true` when [text] is an absolute URI.
  static bool isLink(String text) {
    final uri = Uri.tryParse(text.trim());
    return uri != null && uri.isAbsolute;
  }
}
