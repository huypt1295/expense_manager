import 'package:flutter_common/src/utils/num_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NumExtensions', () {
    test('performs arithmetic operations on num', () {
      num value = 2;
      expect(value.plus(3), 5);
      expect(value.minus(2), 0);
      expect(value.plus(3).times(2), 10);
      expect(value.plus(8).div(2), 5);
    });
  });

  group('IntExtensions', () {
    test('performs arithmetic operations on int', () {
      expect(2.plus(3), 5);
      expect(5.minus(2), 3);
      expect(3.times(4), 12);
      expect(9.div(2), 4.5);
      expect(9.truncateDiv(2), 4);
    });
  });

  group('DoubleExtensions', () {
    test('performs arithmetic operations on double', () {
      expect(2.5.plus(3.5), 6.0);
      expect(5.5.minus(2.0), 3.5);
      expect(3.0.times(4.0), 12.0);
      expect(9.0.div(3.0), 3.0);
    });
  });
}
