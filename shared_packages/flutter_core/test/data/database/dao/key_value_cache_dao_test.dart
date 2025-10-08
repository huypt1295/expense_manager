import 'dart:convert';

import 'package:flutter_core/src/data/database/dao/key_value_cache_dao.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late Database db;
  late KeyValueCacheDao dao;

  setUp(() async {
    db = await databaseFactory.openDatabase(inMemoryDatabasePath);
    await db.execute('''
      CREATE TABLE kv_cache(
        k TEXT PRIMARY KEY,
        v TEXT NOT NULL,
        fetchedAt INTEGER NOT NULL
      )
    ''');
    dao = KeyValueCacheDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('put and get round trip JSON values', () async {
    await dao.put('user/1', {'name': 'Alice'});

    final result = await dao.get('user/1');
    expect(result.$1, {'name': 'Alice'});
    expect(result.$2, isA<DateTime>());
  });

  test('remove and clear delete cached entries', () async {
    await dao.put('page/1', {'items': [1, 2, 3]});
    await dao.put('page/2', {'items': [4, 5]});

    await dao.remove('page/1');
    final first = await dao.get('page/1');
    expect(first.$1, isNull);

    await dao.clear();
    final second = await dao.get('page/2');
    expect(second.$1, isNull);
  });
}
