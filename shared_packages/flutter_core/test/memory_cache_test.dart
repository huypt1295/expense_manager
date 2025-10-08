import 'package:flutter_core/src/data/caching/memory/memory_cache.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MemoryCache', () {
    test('get returns stored value', () {
      final cache = MemoryCache();
      cache.set('answer', 42);

      expect(cache.get<int>('answer'), 42);
    });

    test('get evicts entry when ttl expired', () async {
      final cache = MemoryCache();
      cache.set('answer', 42);

      // TTL in the past forces an eviction
      final result = cache.get<int>('answer', ttl: Duration.zero);
      expect(result, isNull);
      expect(cache.get<int>('answer'), isNull);
    });

    test('invalidate and clear remove entries', () {
      final cache = MemoryCache();
      cache.set('a', 1);
      cache.set('b', 2);

      cache.invalidate('a');
      expect(cache.get<int>('a'), isNull);
      expect(cache.get<int>('b'), 2);

      cache.clear();
      expect(cache.get<int>('b'), isNull);
    });
  });
}
