import 'dart:async';

import 'package:flutter_core/src/data/caching/memory/memory_cache.dart';
import 'package:flutter_core/src/data/caching/policy/cache_policy.dart';
import 'package:flutter_core/src/data/repository/base_cache_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestCacheRepository extends BaseCacheRepository {
  _TestCacheRepository({required super.mem});
}

void main() {
  group('BaseCacheRepository.swr', () {
    test('fetches remote when caches miss', () async {
      final mem = MemoryCache();
      final repo = _TestCacheRepository(mem: mem);
      var remoteCalls = 0;
      String? persisted;

      final values = await repo
          .swr<String>(
        key: 'user',
        policy: const TtlPolicy(ttl: Duration(minutes: 5)),
        remote: () async {
          remoteCalls++;
          return 'fresh';
        },
        local: () async => (null, null),
        saveLocal: (data) async => persisted = data,
      )
          .toList();

      expect(values, ['fresh']);
      expect(remoteCalls, 1);
      expect(mem.get<String>('user'), 'fresh');
      expect(persisted, 'fresh');
    });

    test('emits cached snapshot before remote refresh', () async {
      final mem = MemoryCache();
      final repo = _TestCacheRepository(mem: mem);
      var remoteCalls = 0;
      final fetchedAt = DateTime.now().subtract(const Duration(minutes: 10));

      final values = await repo
          .swr<String>(
        key: 'feed',
        policy: const TtlPolicy(ttl: Duration(minutes: 5)),
        remote: () async {
          remoteCalls++;
          return 'fresh';
        },
        local: () async => ('cached', fetchedAt),
        saveLocal: (data) async {},
        revalidateIfOlderThan: const Duration(minutes: 5),
      )
          .take(2)
          .toList();

      expect(values, ['cached', 'fresh']);
      expect(remoteCalls, 1);
    });

    test('deduplicates concurrent remote refreshes', () async {
      final mem = MemoryCache();
      final repo = _TestCacheRepository(mem: mem);
      var remoteCalls = 0;
      final completer = Completer<String>();

      Future<String> remote() async {
        remoteCalls++;
        return completer.future;
      }

      final futureLists = Future.wait([
        repo
            .swr<String>(
          key: 'profile',
          policy: const TtlPolicy(ttl: Duration(minutes: 1)),
          remote: remote,
          local: () async => (null, null),
          saveLocal: (data) async {},
        )
            .take(1)
            .toList(),
        repo
            .swr<String>(
          key: 'profile',
          policy: const TtlPolicy(ttl: Duration(minutes: 1)),
          remote: remote,
          local: () async => (null, null),
          saveLocal: (data) async {},
        )
            .take(1)
            .toList(),
      ]);

      // Complete the remote call for both listeners.
      completer.complete('fresh');
      final lists = await futureLists;

      expect(remoteCalls, 1);
      expect(lists[0], ['fresh']);
      expect(lists[1], ['fresh']);
    });
  });

  group('BaseCacheRepository.networkFirst', () {
    test('returns fresh data and writes through caches', () async {
      final mem = MemoryCache();
      final repo = _TestCacheRepository(mem: mem);
      String? persisted;

      final result = await repo.networkFirst<String>(
        key: 'user',
        remote: () async => 'fresh',
        local: () async => (null, null),
        saveLocal: (data) async => persisted = data,
      );

      expect(result, 'fresh');
      expect(mem.get<String>('user'), 'fresh');
      expect(persisted, 'fresh');
    });

    test('falls back to memory cache when remote fails', () async {
      final mem = MemoryCache();
      mem.set('user', 'memory');
      final repo = _TestCacheRepository(mem: mem);

      final result = await repo.networkFirst<String>(
        key: 'user',
        remote: () async => throw Exception('offline'),
        local: () async => (null, null),
        saveLocal: (_) async {},
      );

      expect(result, 'memory');
    });

    test('falls back to disk cache when memory is empty', () async {
      final mem = MemoryCache();
      final repo = _TestCacheRepository(mem: mem);

      final result = await repo.networkFirst<String>(
        key: 'user',
        remote: () async => throw Exception('offline'),
        local: () async => ('disk', DateTime.now()),
        saveLocal: (_) async {},
      );

      expect(result, 'disk');
    });

    test('rethrows when both caches miss and remote fails', () async {
      final mem = MemoryCache();
      final repo = _TestCacheRepository(mem: mem);

      expect(
        () => repo.networkFirst<String>(
          key: 'user',
          remote: () async => throw StateError('fail'),
          local: () async => (null, null),
          saveLocal: (_) async {},
        ),
        throwsStateError,
      );
    });
  });
}
