import 'package:sqflite/sqflite.dart';

/// Base DAO for "row ↔ model" mapping on top of SQLite.
///
/// Provides common CRUD utilities and stamps `_fetchedAt` on upsert.
/// TTL/expiry logic is intentionally **not** handled here—use a repository
/// + cache policy instead. Best suited for 1:1 entities (e.g., user_profile).
/// For parameterized lists/search results, prefer `KeyValueCacheDao`.
abstract class BaseSqfliteDao<T> {
  final DatabaseExecutor db;
  final String table;
  final String pk;

  BaseSqfliteDao(
      this.db, {
        required this.table,
        required this.pk,
      });

  /// Map a DB row to the model type.
  T fromMap(Map<String, Object?> row);
  /// Map a model to a DB row (without `_fetchedAt`).
  Map<String, Object?> toMap(T model);

  /// Returns a single row by primary key or null if not found.
  Future<T?> getById(String id) async {
    final rows = await db.query(
      table,
      where: '$pk = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return fromMap(rows.first);
  }

  /// Lấy theo ID (kèm fetchedAt để check TTL ở Repository)
  Future<(T?, DateTime?)> getByIdWithMeta(String id) async {
    final rows = await db.query(
      table,
      where: '$pk = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return (null, null);
    final row = rows.first;
    final ts = row['_fetchedAt'] as int?;
    final fetchedAt = ts != null ? DateTime.fromMillisecondsSinceEpoch(ts) : null;
    return (fromMap(row), fetchedAt);
  }

  /// Returns all rows (use sparingly for large tables).
  Future<List<T>> getAll({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final rows = await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
    return rows.map(fromMap).toList();
  }

  /// Inserts or replaces a model, stamping `_fetchedAt` with `DateTime.now()`.
  Future<void> upsert(T model, {DateTime? fetchedAt}) async {
    final map = toMap(model)
      ..['_fetchedAt'] = (fetchedAt ?? DateTime.now()).millisecondsSinceEpoch;
    await db.insert(
      table,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Batch upsert for multiple models, sharing the same `_fetchedAt`.
  Future<void> upsertAll(Iterable<T> models, {DateTime? fetchedAt}) async {
    final batch = db.batch();
    final ts = (fetchedAt ?? DateTime.now()).millisecondsSinceEpoch;
    for (final m in models) {
      final map = toMap(m)..['_fetchedAt'] = ts;
      batch.insert(
        table,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  /// Deletes a row by primary key.
  Future<int> deleteById(String id) =>
      db.delete(table, where: '$pk = ?', whereArgs: [id]);

  /// Clears all rows in this table.
  Future<int> clear() => db.delete(table);

  /// Count the row
  Future<int> count({String? where, List<Object?>? whereArgs}) async {
    final rows = await db.rawQuery(
      'SELECT COUNT(*) AS c FROM $table${where != null ? ' WHERE $where' : ''}',
      whereArgs,
    );
    return Sqflite.firstIntValue(rows) ?? 0;
  }
}
