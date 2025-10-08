import 'package:flutter_core/src/data/database/dao/base_sqlite_dao.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestEntity {
  const _TestEntity(this.id, this.value);
  final String id;
  final String value;
}

class _TestDao extends BaseSqfliteDao<_TestEntity> {
  _TestDao(super.db)
      : super(table: 'items', pk: 'id');

  @override
  _TestEntity fromMap(Map<String, Object?> row) =>
      _TestEntity(row['id']! as String, row['value']! as String);

  @override
  Map<String, Object?> toMap(_TestEntity model) =>
      {'id': model.id, 'value': model.value};
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late Database db;
  late _TestDao dao;

  setUp(() async {
    db = await databaseFactory.openDatabase(inMemoryDatabasePath);
    await db.execute('''
      CREATE TABLE items(
        id TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        _fetchedAt INTEGER
      )
    ''');
    dao = _TestDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('upsert, getById and getByIdWithMeta work as expected', () async {
    expect(await dao.getById('1'), isNull);

    final entity = _TestEntity('1', 'hello');
    final ts = DateTime(2024, 1, 1);
    await dao.upsert(entity, fetchedAt: ts);

    final fetched = await dao.getById('1');
    expect(fetched?.value, 'hello');

    final withMeta = await dao.getByIdWithMeta('1');
    expect(withMeta.$1?.value, 'hello');
    expect(withMeta.$2, ts);
  });

  test('getAll, delete, clear and count cover DAO helpers', () async {
    await dao.upsertAll([
      const _TestEntity('1', 'a'),
      const _TestEntity('2', 'b'),
    ], fetchedAt: DateTime(2024, 2, 1));

    final all = await dao.getAll(orderBy: 'id ASC');
    expect(all.map((e) => e.id), ['1', '2']);

    expect(await dao.count(), 2);
    expect(await dao.count(where: 'id = ?', whereArgs: ['1']), 1);

    await dao.deleteById('1');
    expect(await dao.count(), 1);

    await dao.clear();
    expect(await dao.count(), 0);
  });
}
