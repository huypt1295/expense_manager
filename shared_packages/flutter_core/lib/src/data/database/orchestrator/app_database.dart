import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'db_module.dart';

/// SQLite orchestrator: opens the DB, ensures shared base tables,
/// and coordinates `DbModule` creation/migrations inside a transaction.
///
/// Responsibilities:
/// - Provide a shared `Database` connection.
/// - Create base/shared tables only (e.g., `schema_meta`, `kv_cache`).
/// - Delegate feature schema work to registered [DbModule]s.
///
/// Does **not** contain feature-specific schema.
class AppDatabase {
  AppDatabase._();
  static Database? _db;
  static final List<DBModule> _modules = [];

  /// Registers a feature module (call before [open]).
  static void registerModule(DBModule module) {
    _modules.add(module);
  }

  /// Opens (or returns) the database and runs module migrations if needed.
  static Future<Database> open({String? fileName}) async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), fileName ?? 'app.db');

    final db = await openDatabase(
      path,
      onConfigure: (db) async {
        // Bật ràng buộc nếu cần
        await db.execute('PRAGMA foreign_keys = ON');
      },
      // Không set version ở đây để tránh “global version conflict”
    );

    await _ensureBaseTables(db);        // bảng chung
    await _runModuleMigrations(db);     // chạy create/migrate theo module
    _db = db;
    return db;
  }

  /// Creates base tables used by the migration system and KV cache.
  static Future<void> _ensureBaseTables(Database db) async {
    // Bảng meta để theo dõi version theo module
    await db.execute('''
      CREATE TABLE IF NOT EXISTS schema_meta(
        module TEXT PRIMARY KEY,
        version INTEGER NOT NULL
      )
    ''');

    // Bảng KV cache dùng chung cho mọi feature
    await db.execute('''
      CREATE TABLE IF NOT EXISTS kv_cache(
        k TEXT PRIMARY KEY,
        v TEXT NOT NULL,
        fetchedAt INTEGER NOT NULL
      )
    ''');
  }

  /// Executes `onCreate`/`migrate` for each registered module
  /// inside a single transaction to guarantee all-or-nothing.
  static Future<void> _runModuleMigrations(Database db) async {
    // Chạy trong transaction để all-or-nothing
    await db.transaction((txn) async {
      for (final m in _modules) {
        final rows = await txn.query('schema_meta',
            columns: ['version'], where: 'module = ?', whereArgs: [m.name], limit: 1);
        final current = rows.isEmpty ? 0 : (rows.first['version'] as int);

        if (current == 0) {
          // Lần đầu cài module
          await m.onCreate(txn);
          await txn.insert('schema_meta', {'module': m.name, 'version': m.schemaVersion},
              conflictAlgorithm: ConflictAlgorithm.replace);
        } else if (current < m.schemaVersion) {
          // Nâng cấp nhiều bước: from -> to
          await m.migrate(txn, current, m.schemaVersion);
          await txn.update('schema_meta', {'version': m.schemaVersion},
              where: 'module = ?', whereArgs: [m.name]);
        }
      }
    });
  }

  static Database get instance {
    final db = _db;
    if (db == null) throw StateError('AppDatabase not opened yet');
    return db;
  }
}
