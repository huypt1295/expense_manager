import 'package:flutter_core/src/data/caching/memory/cache_entry.dart';
import 'package:flutter_core/src/data/caching/memory/memory_cache.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MemoryCache', () {
    late MemoryCache cache;

    setUp(() {
      cache = MemoryCache();
    });

    test('returns cached value after set', () {
      cache.set<int>('answer', 42);

      expect(cache.get<int>('answer'), 42);
    });

    test('evicts entry when ttl expired', () {
      cache.set<String>('session', 'abc');

      final result = cache.get<String>('session', ttl: Duration.zero);

      expect(result, isNull);
      expect(cache.getEntry<String>('session'), isNull);
    });

    test('invalidate removes specific key', () {
      cache.set('first', 1);
      cache.set('second', 2);

      cache.invalidate('first');

      expect(cache.get<int>('first'), isNull);
      expect(cache.get<int>('second'), 2);
    });

    test('clear removes all entries', () {
      cache.set('a', 'value');
      cache.set('b', 'value');

      cache.clear();

      expect(cache.get<String>('a'), isNull);
      expect(cache.get<String>('b'), isNull);
    });

    test('getEntry exposes stored metadata', () {
      cache.set<double>('pi', 3.14);

      final entry = cache.getEntry<double>('pi');

      expect(entry, isA<CacheEntry<double>>());
      expect(entry!.data, 3.14);
      expect(entry.fetchedAt.isAfter(DateTime.now()), isFalse);
    });
  });
}
