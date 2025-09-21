import 'package:sqflite/sqflite.dart';

/// Database "plugin" contract for feature modules.
///
/// Each feature owns its schema lifecycle:
/// - Provide a unique [name] and its [schemaVersion].
/// - Implement [onCreate] for first-time setup (tables, indexes).
/// - Implement [migrate] to upgrade step-by-step from `from` to `to`.
///
/// Registered via `AppDatabase.registerModule(...)`.
abstract class DBModule {
  /// Unique module name
  String get name;
  /// Current schema version of this module.
  int get schemaVersion;

  /// Create tables/indexes when the module is first installed.
  Future<void> onCreate(DatabaseExecutor db);

  /// Upgrade the module schema from [from] (exclusive) to [to] (inclusive),
  /// applying migrations step-by-step (from+1 → ... → to).
  Future<void> migrate(DatabaseExecutor db, int from, int to);
}
