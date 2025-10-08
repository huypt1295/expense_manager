import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/features/budget/data/datasources/budget_remote_data_source.dart';
import 'package:expense_manager/features/budget/data/models/budget_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BudgetRemoteDataSource', () {
    late FakeFirebaseFirestore firestore;
    late BudgetRemoteDataSource dataSource;
    const uid = 'uid-123';

    setUp(() {
      firestore = FakeFirebaseFirestore();
      dataSource = BudgetRemoteDataSource(firestore);
    });

    test('allocateId returns unique id for user budgets collection', () {
      final id1 = dataSource.allocateId(uid);
      final id2 = dataSource.allocateId(uid);

      expect(id1, isNotEmpty);
      expect(id2, isNotEmpty);
      expect(id1, isNot(id2));
    });

    test('upsert writes model data to Firestore', () async {
      final model = BudgetModel(
        id: 'budget-1',
        category: 'Food',
        categoryId: 'food',
        limitAmount: 500,
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 31),
      );

      await dataSource.upsert(uid, model);

      final snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('budgets')
          .doc(model.id)
          .get();

      expect(snapshot.exists, isTrue);
      expect(snapshot.data()?['category'], 'Food');
      expect(snapshot.data()?['categoryId'], 'food');
      expect(snapshot.data()?['limitAmount'], 500);
    });

    test('update merges existing document fields', () async {
      final doc = firestore
          .collection('users')
          .doc(uid)
          .collection('budgets')
          .doc('budget-update');
      await doc.set({
        'category': 'Food',
        'startDate': Timestamp.fromDate(DateTime(2024, 1, 1)),
        'endDate': Timestamp.fromDate(DateTime(2024, 1, 31)),
        'limitAmount': 400,
      });

      final updated = BudgetModel(
        id: 'budget-update',
        category: 'Travel',
        categoryId: 'travel',
        limitAmount: 750,
        startDate: DateTime(2024, 2, 1),
        endDate: DateTime(2024, 2, 28),
      );

      await dataSource.update(uid, updated);

      final snapshot = await doc.get();
      expect(snapshot.data()?['category'], 'Travel');
      expect(snapshot.data()?['limitAmount'], 750);
      expect(snapshot.data()?['categoryId'], 'travel');
    });

    test('delete removes document from collection', () async {
      final doc = firestore
          .collection('users')
          .doc(uid)
          .collection('budgets')
          .doc('budget-delete');
      await doc.set({'category': 'Misc'});

      await dataSource.delete(uid, 'budget-delete');

      expect((await doc.get()).exists, isFalse);
    });

    test('watchBudgets emits models sorted by start date ascending', () async {
      await firestore
          .collection('users')
          .doc(uid)
          .collection('budgets')
          .doc('b-late')
          .set({
        'category': 'Late',
        'categoryId': 'late',
        'limitAmount': 200,
        'startDate': Timestamp.fromDate(DateTime(2024, 3, 1)),
        'endDate': Timestamp.fromDate(DateTime(2024, 3, 31)),
      });

      await firestore
          .collection('users')
          .doc(uid)
          .collection('budgets')
          .doc('b-soon')
          .set({
        'category': 'Soon',
        'categoryId': 'soon',
        'limitAmount': 100,
        'startDate': Timestamp.fromDate(DateTime(2024, 1, 1)),
        'endDate': Timestamp.fromDate(DateTime(2024, 1, 31)),
      });

      final models = await dataSource.watchBudgets(uid).first;
      expect(models, hasLength(2));
      expect(models.first.id, 'b-soon');
      expect(models.last.id, 'b-late');
    });
  });
}
