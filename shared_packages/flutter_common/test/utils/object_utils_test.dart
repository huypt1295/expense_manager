import 'package:flutter_common/src/utils/object_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('run', () {
    test('executes the provided block immediately', () {
      final result = run(() => 5 * 2);

      expect(result, 10);
    });
  });

  group('ObjectUtils.safeCast', () {
    test('returns the value when it matches the target type', () {
      const Object value = 'text';

      expect(value.safeCast<String>(), 'text');
    });

    test('returns null when the cast fails', () {
      const Object value = 42;

      expect(value.safeCast<String>(), isNull);
    });
  });

  group('ObjectUtils.let', () {
    test('invokes callback when value is not null', () {
      const String value = 'hello';

      final result = value.let((it) => it.toUpperCase());

      expect(result, 'HELLO');
    });

    test('returns null when value is null', () {
      const String? value = null;

      final result = value.let((it) => it.toUpperCase());

      expect(result, isNull);
    });
  });

  group('safeCast top-level function', () {
    test('returns the casted value when compatible', () {
      expect(safeCast<int>(42), 42);
    });

    test('returns null when cast is not possible', () {
      expect(safeCast<String>(42), isNull);
    });
  });
}
