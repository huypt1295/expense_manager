import 'package:expense_manager/features/categories/data/datasources/category_remote_data_source.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CategoryRemoteDataSource', () {
    late FakeFirebaseFirestore firestore;
    late CategoryRemoteDataSource dataSource;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      dataSource = CategoryRemoteDataSource(firestore);
    });

    test('fetchAll returns list of category models', () async {
      await firestore.collection('categories').doc('cat-1').set({
        'icon': 'food',
        'isActive': true,
        'names': {'en': 'Food'},
        'sortOrder': 1,
      });

      final models = await dataSource.fetchAll();
      expect(models, hasLength(1));
      expect(models.first.id, 'cat-1');
      expect(models.first.names['en'], 'Food');
    });

    test('watchAll streams category updates', () async {
      final categories = firestore.collection('categories');
      await categories.doc('a').set({
        'icon': 'a',
        'isActive': true,
        'names': {'en': 'A'},
      });
      await categories.doc('b').set({
        'icon': 'b',
        'isActive': false,
        'names': {'en': 'B'},
      });

      final models = await dataSource.watchAll().first;
      expect(models.map((m) => m.id), containsAll(['a', 'b']));
    });
  });
}
