// cache_usecase_presets.dart

import 'package:flutter_core/src/data/caching/policy/cache_policy.dart' show TtlPolicy;

/// Cache preset describing RAM TTL, disk policy, and revalidation throttle.
///
/// - [memTtl]: in-memory TTL (null = never auto-expire; evicted only on kill/invalidate).
/// - [policy]: disk (persistent) TTLs: `ttl` (soft) and `hardTtl`.
/// - [revalidateIfOlderThan]: only revalidate if snapshot is older than this duration.
/// - [jitterPct]: 0..0.3 randomization to avoid synchronized refresh ("stampede").
class CachePreset {
  final Duration? memTtl;
  final TtlPolicy policy;
  final Duration? revalidateIfOlderThan;
  final double jitterPct;

  const CachePreset({
    required this.memTtl,
    required this.policy,
    this.revalidateIfOlderThan,
    this.jitterPct = 0.0,
  });
}

/// Usage-oriented presets (not tied to any specific feature).
/// Pick the one that matches your data/UX behavior.
enum CacheUseCase {
  /// Highly volatile data (prices, live pulse); must stay very fresh.
  realtimeShortLived,

  /// Fast re-entry screens; prioritize instant open, allow slight staleness.
  fastOpenInteractive,

  /// Read-mostly detail views; seldom changes, still refresh periodically.
  readMostlyDetail,

  /// Parameterized lists/search/pagination; frequent filter changes.
  paginatedQuery,

  /// Static/semi-static content (config, banners, catalog).
  staticCatalog,

  /// Usability under poor connectivity; allow long staleness/hard TTL.
  offlineFirst,

  /// Expensive API (rate-limited/costly); throttle revalidation.
  highCostApi,

  /// Prefetch/warmup before the user opens the screen; accept short staleness.
  warmupPrefetch,
}

/// Default presets for common usage patterns (tweak as needed or override via Remote Config).
class CacheUseCasePresets {
  static const realtimeShortLived = CachePreset(
    memTtl: Duration(seconds: 20),
    policy: TtlPolicy(ttl: Duration(seconds: 45), hardTtl: Duration(minutes: 10)),
    revalidateIfOlderThan: Duration(seconds: 15),
    jitterPct: 0.15,
  );

  static const fastOpenInteractive = CachePreset(
    memTtl: Duration(minutes: 2),
    policy: TtlPolicy(ttl: Duration(minutes: 7), hardTtl: Duration(hours: 12)),
    revalidateIfOlderThan: Duration(minutes: 2),
    jitterPct: 0.1,
  );

  static const readMostlyDetail = CachePreset(
    memTtl: Duration(minutes: 3),
    policy: TtlPolicy(ttl: Duration(minutes: 20), hardTtl: Duration(days: 3)),
    revalidateIfOlderThan: Duration(minutes: 5),
    jitterPct: 0.1,
  );

  static const paginatedQuery = CachePreset(
    memTtl: Duration(minutes: 1),
    policy: TtlPolicy(ttl: Duration(minutes: 5), hardTtl: Duration(hours: 12)),
    revalidateIfOlderThan: Duration(minutes: 1),
    jitterPct: 0.1,
  );

  static const staticCatalog = CachePreset(
    memTtl: null,
    policy: TtlPolicy(ttl: Duration(days: 3), hardTtl: Duration(days: 21)),
    revalidateIfOlderThan: Duration(hours: 6),
    jitterPct: 0.05,
  );

  static const offlineFirst = CachePreset(
    memTtl: Duration(minutes: 3),
    policy: TtlPolicy(ttl: Duration(hours: 6), hardTtl: Duration(days: 2)),
    revalidateIfOlderThan: Duration(hours: 1),
    jitterPct: 0.1,
  );

  static const highCostApi = CachePreset(
    memTtl: Duration(minutes: 3),
    policy: TtlPolicy(ttl: Duration(minutes: 30), hardTtl: Duration(days: 2)),
    revalidateIfOlderThan: Duration(minutes: 15),
    jitterPct: 0.2,
  );

  static const warmupPrefetch = CachePreset(
    memTtl: Duration(minutes: 2),
    policy: TtlPolicy(ttl: Duration(minutes: 12), hardTtl: Duration(hours: 6)),
    revalidateIfOlderThan: Duration(minutes: 4),
    jitterPct: 0.1,
  );

  static CachePreset of(CacheUseCase useCase) => switch (useCase) {
    CacheUseCase.realtimeShortLived => realtimeShortLived,
    CacheUseCase.fastOpenInteractive => fastOpenInteractive,
    CacheUseCase.readMostlyDetail => readMostlyDetail,
    CacheUseCase.paginatedQuery => paginatedQuery,
    CacheUseCase.staticCatalog => staticCatalog,
    CacheUseCase.offlineFirst => offlineFirst,
    CacheUseCase.highCostApi => highCostApi,
    CacheUseCase.warmupPrefetch => warmupPrefetch,
  };
}
