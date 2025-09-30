import 'dart:async';

import 'package:flutter_core/src/data/caching/memory/memory_cache.dart';
import 'package:flutter_core/src/data/caching/policy/cache_policy.dart';
import 'package:flutter_core/src/data/repository/base_cache_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestRepo extends BaseCacheRepository {
  _TestRepo({required MemoryCache mem}) : super(mem: mem);
}

void main() {
  group('BaseCacheRepository.swr', () {
    test('emits memory snapshot then fresh value and writes through', () async {
      final mem = MemoryCache();
      final repo = _TestRepo(mem: mem);
      mem.set<String>('resource', 'cached');

      var localCalled = false;
      var savedValue = '';
      var remoteCalls = 0;

      final stream = repo.swr<String>(
        key: 'resource',
        policy: const TtlPolicy(ttl: Duration(minutes: 5)),
        remote: () async {
          remoteCalls++;
          return 'fresh';
        },
        local: () async {
          localCalled = true;
          return ('disk', DateTime.now());
        },
        saveLocal: (value) async {
          savedValue = value;
        },
      );

      final values = await stream.take(2).toList();

      expect(values, ['cached', 'fresh']);
      expect(localCalled, isFalse);
      expect(remoteCalls, 1);
      expect(savedValue, 'fresh');
      expect(mem.get<String>('resource'), 'fresh');
    });

    test('deduplicates concurrent remote refreshes per key', () async {
      final mem = MemoryCache();
      final repo = _TestRepo(mem: mem);
      final completer = Completer<String>();
      var remoteCalls = 0;

      Future<String> remote() {
        remoteCalls++;
        return completer.future;
      }

      final futureA = repo
          .swr<String>(
            key: 'resource',
            policy: const TtlPolicy(ttl: Duration(seconds: 1)),
            remote: remote,
            local: () async => (null, null),
            saveLocal: (_) async {},
          )
          .first;

      final futureB = repo
          .swr<String>(
            key: 'resource',
            policy: const TtlPolicy(ttl: Duration(seconds: 1)),
            remote: remote,
            local: () async => (null, null),
            saveLocal: (_) async {},
          )
          .first;

      await Future<void>.delayed(const Duration(milliseconds: 10));
      completer.complete('fresh');

      final results = await Future.wait([futureA, futureB]);

      expect(results, ['fresh', 'fresh']);
      expect(remoteCalls, 1);
      expect(mem.get<String>('resource'), 'fresh');
    });
  });

  group('BaseCacheRepository.networkFirst', () {
    test('returns fresh data and writes through on success', () async {
      final mem = MemoryCache();
      final repo = _TestRepo(mem: mem);
      var saved = '';

      final value = await repo.networkFirst<String>(
        key: 'item',
        remote: () async => 'fresh',
        local: () async => ('disk', DateTime.now()),
        saveLocal: (data) async => saved = data,
      );

      expect(value, 'fresh');
      expect(saved, 'fresh');
      expect(mem.get<String>('item'), 'fresh');
    });

    test('falls back to memory cache when remote fails', () async {
      final mem = MemoryCache();
      mem.set<String>('item', 'cached');
      final repo = _TestRepo(mem: mem);

      final value = await repo.networkFirst<String>(
        key: 'item',
        remote: () async => throw Exception('offline'),
        local: () async => (null, null),
        saveLocal: (_) async {},
      );

      expect(value, 'cached');
    });

    test('falls back to disk snapshot when memory miss', () async {
      final mem = MemoryCache();
      final repo = _TestRepo(mem: mem);

      final value = await repo.networkFirst<String>(
        key: 'item',
        remote: () async => throw Exception('offline'),
        local: () async => ('disk', DateTime.now()),
        saveLocal: (_) async {},
      );

      expect(value, 'disk');
    });

    test('rethrows when no cache available on failure', () async {
      final mem = MemoryCache();
      final repo = _TestRepo(mem: mem);

      expect(
        () => repo.networkFirst<String>(
          key: 'item',
          remote: () async => throw StateError('boom'),
          local: () async => (null, null),
          saveLocal: (_) async {},
        ),
        throwsA(isA<StateError>()),
      );
    });
  });
}
