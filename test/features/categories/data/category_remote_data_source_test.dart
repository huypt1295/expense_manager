import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/categories/data/datasources/category_remote_data_source.dart';
import 'package:expense_manager/features/categories/data/models/category_model.dart';
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

    test('fetchDefault returns default categories', () async {
      await firestore.collection('categories').doc('cat-1').set({
        'icon': 'food',
        'isActive': true,
        'name': {'en': 'Food'},
        'sortOrder': 1,
      });

      final models = await dataSource.fetchDefault();
      expect(models, hasLength(1));
      final model = models.first;
      expect(model.id, 'cat-1');
      expect(model.isUserDefined, isFalse);
      expect(model.name['en'], 'Food');
    });

    test('fetchForUser returns user categories', () async {
      final doc = firestore
          .collection('users')
          .doc('uid')
          .collection('categories')
          .doc('custom');
      await doc.set({
        'icon': '🎯',
        'isActive': true,
        'type': 'expense',
        'name': {'en': 'Target'},
        'ownerId': 'uid',
      });

      final models = await dataSource.fetchForUser('uid');
      expect(models, hasLength(1));
      expect(models.first.isUserDefined, isTrue);
      expect(models.first.ownerId, 'uid');
    });

    test('watchForUser streams updates', () async {
      final collection = firestore
          .collection('users')
          .doc('user')
          .collection('categories');
      final stream = dataSource.watchForUser('user');

      final expectation = expectLater(
        stream,
        emitsThrough(
          predicate<List<CategoryModel>>((models) {
            return models.any((model) => model.id == 'c2');
          }),
        ),
      );

      await collection.doc('c1').set({
        'icon': '🍕',
        'isActive': true,
        'type': 'expense',
        'name': {'en': 'Pizza'},
      });
      await collection.doc('c2').set({
        'icon': '💡',
        'isActive': true,
        'type': 'income',
        'name': {'en': 'Ideas'},
      });

      await expectation;
    });

    test('createForUser writes document with timestamps', () async {
      final model = CategoryModel(
        id: '',
        icon: '📚',
        isActive: true,
        type: TransactionType.expense,
        name: const {'en': 'Books'},
        isUserDefined: true,
      );

      final created = await dataSource.createForUser('abc', model);

      final snapshot = await firestore
          .collection('users')
          .doc('abc')
          .collection('categories')
          .doc(created.id)
          .get();

      expect(created.ownerId, 'abc');
      expect(snapshot.data()?['ownerId'], 'abc');
      expect(snapshot.data()?['createdAt'], isA<Timestamp>());
      expect(snapshot.data()?['updatedAt'], isA<Timestamp>());
    });
  });
}
