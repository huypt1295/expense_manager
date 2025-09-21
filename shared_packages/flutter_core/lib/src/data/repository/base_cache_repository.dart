import 'package:flutter_core/src/data/caching/policy/cache_policy.dart'
    show CachePolicy, TtlPolicy;
import 'package:flutter_core/src/data/caching/memory/memory_cache.dart'
    show MemoryCache;
import 'package:flutter_core/src/data/exceptions/exception_mapper.dart';


typedef RemoteFetcher<T> = Future<T> Function();

/// Reads the latest persistent snapshot (if any) and its timestamp.
/// Returns a tuple of:
/// - `T?`        : the decoded snapshot (null if not found)
/// - `DateTime?` : the last known fetch time used for TTL decisions
typedef LocalReader<T> = Future<(T?, DateTime?)> Function();

/// Persists a fresh snapshot to disk (e.g., SQLite/Hive) after a successful remote fetch.
/// Should be idempotent and safe to call repeatedly.
typedef LocalWriter<T> = Future<void> Function(T data);

class BaseCacheRepository with RepoErrorMapper {
  final MemoryCache mem;
  final Map<String, Future<dynamic>> _inFlight = {};

  BaseCacheRepository({required this.mem});

  /// Stale-While-Revalidate stream helper.
  ///
  /// High-level flow (per subscription):
  /// 1) **RAM**: Try in-memory cache (`mem.get(key, ttl: memTtl)`). If hit, **emit** immediately.
  /// 2) **Disk**: If RAM miss, read persistent cache via [local]. If not **hard-expired**, **emit**.
  /// 3) **Revalidate**: Optionally call [remote], then [saveLocal], write RAM, and **emit fresh**.
  ///
  /// Emission contract:
  /// - The stream may emit **0..2 data events** per subscription (snapshot → fresh),
  ///   plus an **error** if the remote step fails *and* no snapshot was emitted earlier.
  /// - If a snapshot was already emitted (RAM/disk), a later remote failure will surface
  ///   as a stream error only if you do not catch it here (current implementation forwards it).
  ///
  /// Concurrency / de-dup:
  /// - Calls sharing the same [key] are **de-duplicated**: only one remote request is in-flight,
  ///   and its result is shared among concurrent subscribers.
  ///
  /// Parameters:
  /// - [key]  : Unique cache key for this resource (include parameters like userId/page/filter).
  /// - [policy] : Disk cache policy (soft TTL via `ttl`, hard expiry via `hardTtl`).
  ///              *Soft TTL* = allowed to render but considered stale; *Hard TTL* = do not render.
  /// - [remote] : Asynchronous function that fetches the **fresh** value from the network.
  /// - [local]  : Reads the latest **persistent** snapshot and its `fetchedAt`.
  /// - [saveLocal] : Persists a fresh value to disk after a successful [remote] call.
  /// - [memTtl] : Optional TTL for **memory** cache only. If null, RAM entries never auto-expire
  ///              (they are still evicted when the app process dies or you call `invalidate`).
  /// - [revalidateIfOlderThan] :
  ///     When **provided**, the remote step runs **only if** the current snapshot `age >= this`.
  ///     This is the main switch to avoid revalidating when cache is still “fresh enough.”
  ///     If **null**, revalidation will **always** run after emitting a snapshot (aggressive SWR).
  /// - [jitterPct] : Adds up to `jitterPct` (0..0.3) randomization to [revalidateIfOlderThan]
  ///                 to avoid synchronized refresh spikes (“cache stampede”).
  ///
  /// Age source:
  /// - If a RAM hit occurs and `MemoryCache` exposes `fetchedAt` (via `getEntry`), that timestamp
  ///   is used for age; otherwise the disk snapshot’s `fetchedAt` is used.
  ///
  /// Hard TTL:
  /// - If `policy.hardTtl` is configured and the disk snapshot is **hard-expired**, it will **not**
  ///   be emitted in step (2); the flow proceeds to revalidate or fail if offline.
  ///
  /// Typical usage:
  /// - To mirror the classic “don’t revalidate while still fresh” behavior, pass
  ///   `revalidateIfOlderThan: policy.ttl` (or a slightly smaller multiple if you want earlier refresh).
  Stream<T> swr<T>({
    required String key,
    required CachePolicy policy,
    required RemoteFetcher<T> remote,
    required LocalReader<T> local,
    required LocalWriter<T> saveLocal,
    Duration? memTtl,
    Duration? revalidateIfOlderThan, // optional throttling
    double jitterPct = 0.0, // optional jitter to mitigate stampede
  }) async* {
    final now = DateTime.now();

    // 1) Try RAM (fast path). If memTtl is set and expired, MemoryCache will evict the entry.
    final memHit = mem.get<T>(key, ttl: memTtl);
    DateTime? age;

    if (memHit != null) {
      // Emit memory snapshot immediately for snappy UX.
      yield memHit;

      // If available, keep the RAM timestamp as the age reference.
      age = mem.getEntry<T>(key)?.fetchedAt;
    }

    // 2) Try disk if RAM missed (or if you want a more conservative age reference).
    if (memHit == null) {
      final (disk, fetchedAt) = await local();
      if (disk != null) {
        // Respect hard TTL: do not render an over-expired disk snapshot.
        final hardExpired = (policy is TtlPolicy) &&
            (fetchedAt != null) &&
            policy.isHardExpired(fetchedAt);
        if (!hardExpired) {
          yield disk;
          age = fetchedAt ?? age;
        }
      }
    }

    // Decide whether to revalidate now.
    bool shouldRevalidate() {
      // If no threshold provided, always revalidate (aggressive SWR).
      if (revalidateIfOlderThan == null || age == null) return true;

      // Add jitter to spread out refreshes across clients.
      final clamped = jitterPct.clamp(0.0, 0.3);
      final jitterMillis =
          (revalidateIfOlderThan.inMilliseconds * clamped).toInt();
      final jitter = Duration(milliseconds: jitterMillis);

      // Revalidate only if snapshot age >= threshold (+ jitter).
      return now.isAfter(age.add(revalidateIfOlderThan + jitter));
    }

    if (shouldRevalidate()) {
      // De-dup in-flight remote calls for the same key.
      final fut = _inFlight[key] ??= _refresh<T>(
        key: key,
        remote: remote,
        saveLocal: saveLocal,
      );
      try {
        final fresh = await fut as T;
        // Write-through: persist to disk and then cache in memory.
        mem.set<T>(key, fresh);
        yield fresh;
      } finally {
        _inFlight.remove(key);
      }
    }
  }

  /// Network-first helper.
  ///
  /// Strategy:
  /// 1) Try [remote]. On success:
  ///    - Persist via [saveLocal] (write-through),
  ///    - Put into memory cache (`mem.set(key, fresh)`),
  ///    - Return the fresh value.
  /// 2) On remote failure:
  ///    - Try **RAM** (`mem.get(key, ttl: memTtl)`). If hit, return it.
  ///    - Else try **disk** via [local]. If present, return it.
  ///    - Else rethrow the original remote exception.
  ///
  /// Use when **freshness** is preferred over instant open, but you still want
  /// graceful degradation (serve last-known snapshot) under network errors.
  ///
  /// Parameters:
  /// - [key]       : Unique cache key (include parameters like userId/page/filter).
  /// - [remote]    : Fetches the **fresh** value from the network.
  /// - [local]     : Reads the latest persisted snapshot and its timestamp (the
  ///                 timestamp is not used here but kept for a consistent signature).
  /// - [saveLocal] : Persists a fresh value after a successful [remote] call.
  /// - [memTtl]    : Optional TTL for **memory** cache only. If null, RAM entries
  ///                 do not auto-expire (still evicted on app kill/invalidate).
  ///
  /// Notes:
  /// - This method does **not** de-duplicate concurrent remote calls. If you need
  ///   de-duplication or a “snapshot → fresh” emission pattern, prefer [swr].
  /// - [saveLocal] should be idempotent; it may be invoked repeatedly.
  ///
  /// Errors:
  /// - If the remote fails **and** no RAM/disk snapshot exists, the original
  ///   exception is rethrown to the caller.
  Future<T> networkFirst<T>({
    required String key,
    required RemoteFetcher<T> remote,
    required LocalReader<T> local,
    required LocalWriter<T> saveLocal,
    Duration? memTtl,
  }) async {
    try {
      // Remote first: the freshest possible data.
      final fresh = await remote();

      // Write-through: persist to disk, then store in memory for fast re-reads.
      await saveLocal(fresh);
      mem.set<T>(key, fresh);

      return fresh;
    } catch (_) {
      // Remote failed → graceful fallback chain.

      // 1) Try memory cache (fast).
      final memHit = mem.get<T>(key, ttl: memTtl);
      if (memHit != null) return memHit;

      // 2) Try persistent cache (disk).
      final (loc, _) = await local();
      if (loc != null) return loc;

      // 3) Nothing to serve → bubble up original error.
      rethrow;
    }
  }

  Future<T> _refresh<T>({
    required String key,
    required RemoteFetcher<T> remote,
    required LocalWriter<T> saveLocal,
  }) async {
    final data = await remote();
    await saveLocal(data); // write-through to persistent cache
    return data;
  }
}
