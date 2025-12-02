import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:expense_manager/features/categories/data/datasources/category_remote_data_source.dart';
import 'package:expense_manager/features/categories/data/models/category_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CategoryRemoteDataSource', () {
    late FakeFirebaseFirestore firestore;
    late CategoryRemoteDataSource dataSource;

    const context = WorkspaceContext(
      userId: 'uid',
      workspaceId: 'ws-1',
      type: WorkspaceType.personal,
    );

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

    test('fetchForWorkspace returns workspace categories', () async {
      final doc = firestore
          .collection('workspaces')
          .doc('ws-1')
          .collection('customCategories')
          .doc('custom');
      await doc.set({
        'icon': '🎯',
        'isActive': true,
        'type': 'expense',
        'name': {'en': 'Target'},
        'ownerId': 'uid',
      });

      final models = await dataSource.fetchForWorkspace(context);
      expect(models, hasLength(1));
      expect(models.first.isUserDefined, isTrue);
      expect(models.first.ownerId, 'uid');
    });

    test('watchForWorkspace streams updates', () async {
      final collection = firestore
          .collection('workspaces')
          .doc('ws-1')
          .collection('customCategories');
      final stream = dataSource.watchForWorkspace(context);

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

    test('createForWorkspace writes document with timestamps', () async {
      final model = CategoryModel(
        id: '',
        icon: '📚',
        isActive: true,
        type: TransactionType.expense,
        name: const {'en': 'Books'},
        isUserDefined: true,
      );

      final created = await dataSource.createForWorkspace(context, model);

      final snapshot = await firestore
          .collection('workspaces')
          .doc('ws-1')
          .collection('customCategories')
          .doc(created.id)
          .get();

      expect(
        created.ownerId,
        isNull,
      ); // Owner ID is set by repository, not data source
      expect(snapshot.data()?['createdAt'], isA<Timestamp>());
      expect(snapshot.data()?['updatedAt'], isA<Timestamp>());
    });
  });
}
