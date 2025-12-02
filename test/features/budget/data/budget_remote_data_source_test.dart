import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:expense_manager/features/budget/data/datasources/budget_remote_data_source.dart';
import 'package:expense_manager/features/budget/data/models/budget_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BudgetRemoteDataSource', () {
    late FakeFirebaseFirestore firestore;
    late BudgetRemoteDataSource dataSource;
    const uid = 'uid-123';
    const householdId = 'household-123';
    late WorkspaceContext personalContext;
    late WorkspaceContext householdContext;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      dataSource = BudgetRemoteDataSource(firestore);
      personalContext = WorkspaceContext(
        userId: uid,
        workspaceId: uid,
        type: WorkspaceType.personal,
      );
      householdContext = const WorkspaceContext(
        userId: uid,
        workspaceId: householdId,
        type: WorkspaceType.workspace,
      );
    });

    test('allocateId returns unique id for user budgets collection', () {
      final id1 = dataSource.allocateId(personalContext);
      final id2 = dataSource.allocateId(personalContext);

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

      await dataSource.upsert(personalContext, model);

      final snapshot = await firestore
          .collection('workspaces')
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
          .collection('workspaces')
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

      await dataSource.update(personalContext, updated);

      final snapshot = await doc.get();
      expect(snapshot.data()?['category'], 'Travel');
      expect(snapshot.data()?['limitAmount'], 750);
      expect(snapshot.data()?['categoryId'], 'travel');
    });

    test(
      'upsert writes to household collection when context is household',
      () async {
        final model = BudgetModel(
          id: 'household-budget',
          category: 'Utilities',
          categoryId: 'utilities',
          limitAmount: 800,
          startDate: DateTime(2024, 4, 1),
          endDate: DateTime(2024, 4, 30),
        );

        await dataSource.upsert(householdContext, model);

        final snapshot = await firestore
            .collection('workspaces')
            .doc(householdId)
            .collection('budgets')
            .doc('household-budget')
            .get();

        expect(snapshot.exists, isTrue);
        expect(snapshot.data()?['category'], 'Utilities');
      },
    );

    test('delete removes document from collection', () async {
      final doc = firestore
          .collection('workspaces')
          .doc(uid)
          .collection('budgets')
          .doc('budget-delete');
      await doc.set({'category': 'Misc'});

      await dataSource.delete(personalContext, 'budget-delete');

      expect((await doc.get()).exists, isFalse);
    });

    test('watchBudgets emits models sorted by start date ascending', () async {
      await firestore
          .collection('workspaces')
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
          .collection('workspaces')
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

      final models = await dataSource.watchBudgets(personalContext).first;
      expect(models, hasLength(2));
      expect(models.first.id, 'b-soon');
      expect(models.last.id, 'b-late');
    });
  });
}
