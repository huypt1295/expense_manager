import 'dart:io';

import 'package:flutter_core/src/data/database/orchestrator/app_database.dart';
import 'package:flutter_core/src/data/database/orchestrator/db_module.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _FakeModule extends DBModule {
  _FakeModule(this._name, this._schemaVersion);

  final String _name;
  final int _schemaVersion;

  int createCalls = 0;
  int migrateCalls = 0;

  @override
  String get name => _name;

  @override
  int get schemaVersion => _schemaVersion;

  @override
  Future<void> onCreate(DatabaseExecutor db) async {
    createCalls += 1;
    await db.execute('CREATE TABLE IF NOT EXISTS ${_name}_table(id TEXT PRIMARY KEY)');
  }

  @override
  Future<void> migrate(DatabaseExecutor db, int from, int to) async {
    migrateCalls += 1;
    await db.execute('ALTER TABLE ${_name}_table ADD COLUMN version INTEGER DEFAULT $to');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('AppDatabase registers modules and runs migrations', () async {
    await AppDatabase.resetForTest();
    final tempDir = await Directory.systemTemp.createTemp('app_db_test');
    final originalPath = await databaseFactoryFfi.getDatabasesPath();
    await databaseFactoryFfi.setDatabasesPath(tempDir.path);

    final moduleV1 = _FakeModule('feature', 1);
    AppDatabase.registerModule(moduleV1);

    final db = await AppDatabase.open(fileName: 'coverage.db');
    expect(moduleV1.createCalls, 1);
    expect(moduleV1.migrateCalls, 0);

    // Simulate module upgrade.
    await AppDatabase.resetForTest();
    final moduleV2 = _FakeModule('feature', 2);
    AppDatabase.registerModule(moduleV2);
    final reopened = await AppDatabase.open(fileName: 'coverage.db');
    expect(reopened.isOpen, isTrue);
    expect(moduleV2.createCalls, 0);
    expect(moduleV2.migrateCalls, 1);

    await db.close();
    await AppDatabase.resetForTest();
    await databaseFactoryFfi.setDatabasesPath(originalPath);
    await tempDir.delete(recursive: true);
  });
}
