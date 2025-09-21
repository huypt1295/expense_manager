
/// In-memory cache entry for a single app session.
class CacheEntry<T> {
  final T data;
  final DateTime fetchedAt;

  CacheEntry(this.data, this.fetchedAt);
}
