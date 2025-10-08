import 'package:flutter_core/src/data/caching/policy/cache_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TtlPolicy', () {
    test('isExpired respects ttl', () {
      final policy = TtlPolicy(ttl: const Duration(seconds: 1));
      final past = DateTime.now().subtract(const Duration(seconds: 2));
      final recent = DateTime.now();

      expect(policy.isExpired(past), isTrue);
      expect(policy.isExpired(recent), isFalse);
    });

    test('isHardExpired respects hard ttl', () {
      final policy = TtlPolicy(
        ttl: const Duration(seconds: 1),
        hardTtl: const Duration(seconds: 5),
      );
      final tooOld = DateTime.now().subtract(const Duration(seconds: 10));
      final fresh = DateTime.now();

      expect(policy.isHardExpired(tooOld), isTrue);
      expect(policy.isHardExpired(fresh), isFalse);
    });
  });
}
