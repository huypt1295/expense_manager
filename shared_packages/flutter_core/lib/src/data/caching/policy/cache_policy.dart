
/// Cache policy for **persistent** storage (DB/file).
///
/// Two notions:
/// - `ttl` (soft TTL): beyond this, the snapshot is considered *stale*—you may still
///   render it immediately for UX and then revalidate in the background.
/// - `hardTtl` (hard expiry): beyond this, the snapshot is **not** safe for initial render;
///   you must fetch remotely (unless you intentionally allow a "grace mode" offline).
sealed class CachePolicy {
  const CachePolicy();

  /// Returns whether the soft TTL has expired for the given [fetchedAt].
  bool isExpired(DateTime fetchedAt);
}

/// Default TTL-based policy.
///
/// Use it in repositories to decide whether to emit a disk snapshot,
/// whether to trigger a background revalidation, and when to reject stale data.
final class TtlPolicy extends CachePolicy {
  final Duration ttl; // Time To Live
  final Duration? hardTtl;
  const TtlPolicy({required this.ttl, this.hardTtl});

  @override
  bool isExpired(DateTime fetchedAt) =>
      DateTime.now().isAfter(fetchedAt.add(ttl));

  /// Returns true if the hard TTL has elapsed.
  bool isHardExpired(DateTime fetchedAt) =>
      hardTtl == null ? false : DateTime.now().isAfter(fetchedAt.add(hardTtl!));
}
