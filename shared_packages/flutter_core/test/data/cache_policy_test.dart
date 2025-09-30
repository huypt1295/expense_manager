import 'package:flutter_core/src/data/caching/policy/cache_policy.dart';
import 'package:flutter_core/src/data/caching/policy/cache_presets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TtlPolicy', () {
    test('isExpired returns false before threshold', () {
      const policy = TtlPolicy(ttl: Duration(minutes: 1));
      final fetchedAt = DateTime.now();

      expect(policy.isExpired(fetchedAt), isFalse);
    });

    test('isExpired returns true after threshold', () {
      const policy = TtlPolicy(ttl: Duration(seconds: 2));
      final fetchedAt = DateTime.now().subtract(const Duration(seconds: 3));

      expect(policy.isExpired(fetchedAt), isTrue);
    });

    test('hard TTL defaults to not expired', () {
      const policy = TtlPolicy(ttl: Duration(seconds: 5));
      final fetchedAt = DateTime.now().subtract(const Duration(hours: 1));

      expect(policy.isHardExpired(fetchedAt), isFalse);
    });

    test('hard TTL triggers expiration when provided', () {
      const policy = TtlPolicy(
        ttl: Duration(minutes: 1),
        hardTtl: Duration(minutes: 5),
      );
      final fetchedAt = DateTime.now().subtract(const Duration(minutes: 10));

      expect(policy.isHardExpired(fetchedAt), isTrue);
    });
  });

  group('CacheUseCasePresets', () {
    test('of returns matching preset by use case', () {
      expect(
        CacheUseCasePresets.of(CacheUseCase.staticCatalog),
        same(CacheUseCasePresets.staticCatalog),
      );
      expect(
        CacheUseCasePresets.of(CacheUseCase.realtimeShortLived),
        same(CacheUseCasePresets.realtimeShortLived),
      );
    });

    test('preset exposes configuration values', () {
      const preset = CachePreset(
        memTtl: Duration(seconds: 30),
        policy: TtlPolicy(ttl: Duration(minutes: 2)),
      );

      expect(preset.memTtl, const Duration(seconds: 30));
      expect(preset.policy.ttl, const Duration(minutes: 2));
      expect(preset.policy.hardTtl, isNull);
      expect(preset.jitterPct, 0.0);
    });
  });
}
