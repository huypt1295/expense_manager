import 'package:flutter_common/src/utils/validation_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ensureInitializedForTesting does not throw', () {
    expect(ValidationUtils.ensureInitializedForTesting, returnsNormally);
  });

  group('ValidationUtils.isValidPassword', () {
    test('returns true when password is not empty', () {
      expect(ValidationUtils.isValidPassword('password'), isTrue);
    });

    test('returns false when password is empty', () {
      expect(ValidationUtils.isValidPassword(''), isFalse);
    });
  });

  group('ValidationUtils.isEmptyPhoneNumber', () {
    test('returns false when phone number is empty', () {
      expect(ValidationUtils.isEmptyPhoneNumber(''), isFalse);
    });

    test('returns true when phone number is not empty', () {
      expect(ValidationUtils.isEmptyPhoneNumber('123'), isTrue);
    });
  });

  group('ValidationUtils.isValidPhoneNumber', () {
    test('returns true for numbers with 10 or 11 digits', () {
      expect(ValidationUtils.isValidPhoneNumber('0123456789'), isTrue);
      expect(ValidationUtils.isValidPhoneNumber('01234567890'), isTrue);
      expect(ValidationUtils.isValidPhoneNumber(' 0123456789 '), isTrue);
    });

    test('returns false for invalid patterns', () {
      expect(ValidationUtils.isValidPhoneNumber('1234'), isFalse);
      expect(ValidationUtils.isValidPhoneNumber('phone123'), isFalse);
    });
  });

  group('ValidationUtils.isEmptyEmail', () {
    test('returns false when email is empty', () {
      expect(ValidationUtils.isEmptyEmail(''), isFalse);
    });

    test('returns true when email is not empty', () {
      expect(ValidationUtils.isEmptyEmail('user@example.com'), isTrue);
    });
  });

  group('ValidationUtils.isValidEmail', () {
    test('returns true for valid email addresses', () {
      expect(ValidationUtils.isValidEmail('user@example.com'), isTrue);
      expect(ValidationUtils.isValidEmail('  user@example.com  '), isTrue);
    });

    test('returns false for invalid email addresses', () {
      expect(ValidationUtils.isValidEmail('user@'), isFalse);
    });
  });

  group('ValidationUtils.isEmptyDateTime', () {
    test('returns false when date time is empty', () {
      expect(ValidationUtils.isEmptyDateTime(''), isFalse);
    });

    test('returns true when date time is not empty', () {
      expect(ValidationUtils.isEmptyDateTime('2024-01-01'), isTrue);
    });
  });

  group('ValidationUtils.isValidDateTime', () {
    test('returns true for valid date patterns', () {
      expect(ValidationUtils.isValidDateTime('29/02/2024'), isTrue);
      expect(ValidationUtils.isValidDateTime('31-01-2024'), isTrue);
    });

    test('returns false for invalid date patterns', () {
      expect(ValidationUtils.isValidDateTime('31/02/2023'), isFalse);
      expect(ValidationUtils.isValidDateTime('not a date'), isFalse);
    });
  });

  group('ValidationUtils.isAlphanumeric', () {
    test('returns true for alphanumeric input', () {
      expect(ValidationUtils.isAlphanumeric('Abc123'), isTrue);
      expect(ValidationUtils.isAlphanumeric(' Abc123 '), isTrue);
    });

    test('returns false when input contains separators', () {
      expect(ValidationUtils.isAlphanumeric('abc_123'), isFalse);
    });
  });

  group('ValidationUtils.isLink', () {
    test('returns true for absolute URIs', () {
      expect(ValidationUtils.isLink('https://example.com'), isTrue);
      expect(ValidationUtils.isLink('  https://example.com  '), isTrue);
    });

    test('returns false for relative URIs', () {
      expect(ValidationUtils.isLink('www.example.com'), isFalse);
    });

    test('throws when the uri cannot be parsed', () {
      expect(ValidationUtils.isLink('not a uri'), isFalse);
    });
  });
}
