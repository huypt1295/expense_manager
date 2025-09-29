import 'dart:convert';
import 'package:sqflite/sqflite.dart';

/// Lightweight "key -> JSON" cache table for parameterized responses
/// (search results, pagination pages, filtered lists).
///
/// Stores raw JSON plus a `fetchedAt` timestamp for TTL decisions in repositories.
class KeyValueCacheDao {
  final Database db;
  KeyValueCacheDao(this.db);

  /// Puts a JSON-serializable object under [key], stamping `fetchedAt`.
  Future<void> put(String key, Object jsonSerializable) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.insert(
      'kv_cache',
      {'k': key, 'v': jsonEncode(jsonSerializable), 'fetchedAt': now},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Returns decoded JSON (as Map) and its `fetchedAt` timestamp.
  Future<(Map<String, dynamic>?, DateTime?)> get(String key) async {
    final rows = await db.query('kv_cache', where: 'k = ?', whereArgs: [key], limit: 1);
    if (rows.isEmpty) return (null, null);
    final row = rows.first;
    final v = jsonDecode(row['v'] as String) as Map<String, dynamic>;
    final fetchedAt = DateTime.fromMillisecondsSinceEpoch(row['fetchedAt'] as int);
    return (v, fetchedAt);
  }

  /// Deletes a single key.
  Future<void> remove(String key) async {
    await db.delete('kv_cache', where: 'k = ?', whereArgs: [key]);
  }

  /// Clears the entire KV cache table.
  Future<void> clear() async => db.delete('kv_cache');
}
