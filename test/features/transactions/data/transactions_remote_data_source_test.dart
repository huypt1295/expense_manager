import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:expense_manager/features/transactions/data/datasources/transactions_remote_data_source.dart';
import 'package:expense_manager/features/transactions/data/models/transaction_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransactionsRemoteDataSource', () {
    late FakeFirebaseFirestore firestore;
    late TransactionsRemoteDataSource dataSource;
    const uid = 'uid-456';
    const householdId = 'household-123';
    late WorkspaceContext personalContext;
    late WorkspaceContext householdContext;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      dataSource = TransactionsRemoteDataSource(firestore);
      personalContext =
          const WorkspaceContext(userId: uid, workspaceId: uid, type: WorkspaceType.personal);
      householdContext = const WorkspaceContext(
        userId: uid,
        workspaceId: householdId,
        type: WorkspaceType.workspace,
      );
    });

    test('allocateId returns unique id per user collection', () {
      final id1 = dataSource.allocateId(personalContext);
      final id2 = dataSource.allocateId(personalContext);

      expect(id1, isNotEmpty);
      expect(id1, isNot(id2));
    });

    test('upsert writes transaction payload', () async {
      final model = TransactionModel(
        id: 'tx-1',
        title: 'Coffee',
        amount: 42.5,
        date: DateTime(2024, 1, 1),
        type: TransactionType.expense,
        category: 'Food',
        note: 'morning',
      );

      await dataSource.upsert(personalContext, model);

      final snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .doc('tx-1')
          .get();

      expect(snapshot.exists, isTrue);
      expect(snapshot.data()?['title'], 'Coffee');
      expect(snapshot.data()?['amount'], 42.5);
      expect(snapshot.data()?['deleted'], isFalse);
    });

    test('update merges existing transaction', () async {
      final doc = firestore
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .doc('tx-merge');
      await doc.set({
        'title': 'Old',
        'amount': 10,
        'date': Timestamp.fromDate(DateTime(2024, 1, 1)),
        'deleted': false,
      });

      final updated = TransactionModel(
        id: 'tx-merge',
        title: 'New',
        amount: 20,
        date: DateTime(2024, 1, 2),
        type: TransactionType.expense,
        category: 'Travel',
        note: 'note',
      );

      await dataSource.update(personalContext, updated);

      final snapshot = await doc.get();
      expect(snapshot.data()?['title'], 'New');
      expect(snapshot.data()?['amount'], 20);
      expect(snapshot.data()?['category'], 'Travel');
      expect(snapshot.data()?['deleted'], isFalse);
    });

    test('softDelete marks transaction as deleted', () async {
      final doc = firestore
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .doc('tx-delete');
      await doc.set({'deleted': false});

      await dataSource.softDelete(personalContext, 'tx-delete');

      final snapshot = await doc.get();
      expect(snapshot.data()?['deleted'], isTrue);
    });

    test('watchTransactions emits non-deleted transactions sorted desc by date', () async {
      final collection = firestore
          .collection('users')
          .doc(uid)
          .collection('transactions');

      await collection.doc('old').set({
        'title': 'Old',
        'amount': 10,
        'date': Timestamp.fromDate(DateTime(2024, 1, 1)),
        'deleted': false,
      });
      await collection.doc('recent').set({
        'title': 'Recent',
        'amount': 20,
        'date': Timestamp.fromDate(DateTime(2024, 2, 1)),
        'deleted': false,
      });
      await collection.doc('deleted').set({
        'title': 'Deleted',
        'amount': 30,
        'date': Timestamp.fromDate(DateTime(2024, 3, 1)),
        'deleted': true,
      });

      final models = await dataSource.watchTransactions(personalContext).first;
      expect(models.map((m) => m.id), ['recent', 'old']);
    });

    test('fetchTransactionsOnce mirrors watcher filtering', () async {
      final collection = firestore
          .collection('users')
          .doc(uid)
          .collection('transactions');

      await collection.doc('once1').set({
        'title': 'Once1',
        'amount': 10,
        'date': Timestamp.fromDate(DateTime(2024, 1, 1)),
        'deleted': false,
      });
      await collection.doc('once2').set({
        'title': 'Once2',
        'amount': 15,
        'date': Timestamp.fromDate(DateTime(2024, 2, 1)),
        'deleted': true,
      });

      final models = await dataSource.fetchTransactionsOnce(personalContext);
      expect(models, hasLength(1));
      expect(models.first.id, 'once1');
    });

    test('upsert stores share metadata when provided', () async {
      final model = TransactionModel(
        id: 'shared',
        title: 'Shared',
        amount: 50,
        date: DateTime(2024, 3, 1),
        type: TransactionType.expense,
        category: 'Food',
        note: null,
        sharedFromWorkspaceId: 'personal-1',
        sharedFromTransactionId: 'tx-original',
        sharedByUserId: 'uid-123',
      );

      await dataSource.upsert(householdContext, model);

      final doc = await firestore
          .collection('households')
          .doc(householdId)
          .collection('transactions')
          .doc('shared')
          .get();

      expect(doc.exists, isTrue);
      expect(doc.data()?['sharedFromWorkspaceId'], 'personal-1');
      expect(doc.data()?['sharedFromTransactionId'], 'tx-original');
      expect(doc.data()?['sharedByUserId'], 'uid-123');
    });

    test('household context reads and writes from household collection', () async {
      final model = TransactionModel(
        id: 'household-tx',
        title: 'Groceries',
        amount: 80,
        date: DateTime(2024, 2, 2),
        type: TransactionType.expense,
        category: 'Food',
        note: null,
      );

      await dataSource.upsert(householdContext, model);

      final doc = await firestore
          .collection('households')
          .doc(householdId)
          .collection('transactions')
          .doc('household-tx')
          .get();

      expect(doc.exists, isTrue);

      final fetched = await dataSource.fetchTransactionsOnce(householdContext);
      expect(fetched, hasLength(1));
      expect(fetched.first.id, 'household-tx');
    });
  });
}
