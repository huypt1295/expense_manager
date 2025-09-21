import 'package:flutter_core/src/data/caching/memory/cache_entry.dart' show CacheEntry;

/// Ultra-light memory cache to deliver instant reads within the same session.
///
/// Notes:
/// - Not persistent (evicted when app is killed).
/// - Can be time-bound via `get(key, ttl: ...)`.
/// - Great for avoiding DB I/O and (de)serialization on quick back/forward navigation.
class MemoryCache {
  final _store = <String, CacheEntry<dynamic>>{};

  /// Gets a cached value by [key]. If [ttl] is provided and expired, the entry is evicted.
  T? get<T>(String key, {Duration? ttl}) {
    final e = _store[key];
    if (e == null) return null;

    if (ttl != null && DateTime.now().isAfter(e.fetchedAt.add(ttl))) {
      _store.remove(key);
      return null;
    }
    return e.data as T;
  }

  /// Sets a cached value (no size constraints; add your own if needed).
  void set<T>(String key, T data) {
    _store[key] = CacheEntry<T>(data, DateTime.now());
  }

  /// Removes a single key.
  void invalidate(String key) => _store.remove(key);

  /// Clears the entire in-memory cache.
  void clear() => _store.clear();

  /// (Optional) Access the raw entry (to read fetchedAt).
  CacheEntry<T>? getEntry<T>(String key) => _store[key] as CacheEntry<T>?;
}
