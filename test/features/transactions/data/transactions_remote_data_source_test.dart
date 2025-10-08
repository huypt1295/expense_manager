import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/features/transactions/data/datasources/transactions_remote_data_source.dart';
import 'package:expense_manager/features/transactions/data/models/transaction_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransactionsRemoteDataSource', () {
    late FakeFirebaseFirestore firestore;
    late TransactionsRemoteDataSource dataSource;
    const uid = 'uid-456';

    setUp(() {
      firestore = FakeFirebaseFirestore();
      dataSource = TransactionsRemoteDataSource(firestore);
    });

    test('allocateId returns unique id per user collection', () {
      final id1 = dataSource.allocateId(uid);
      final id2 = dataSource.allocateId(uid);

      expect(id1, isNotEmpty);
      expect(id1, isNot(id2));
    });

    test('upsert writes transaction payload', () async {
      final model = TransactionModel(
        id: 'tx-1',
        title: 'Coffee',
        amount: 42.5,
        date: DateTime(2024, 1, 1),
        category: 'Food',
        note: 'morning',
      );

      await dataSource.upsert(uid, model);

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
        category: 'Travel',
        note: 'note',
      );

      await dataSource.update(uid, updated);

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

      await dataSource.softDelete(uid, 'tx-delete');

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

      final models = await dataSource.watchTransactions(uid).first;
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

      final models = await dataSource.fetchTransactionsOnce(uid);
      expect(models, hasLength(1));
      expect(models.first.id, 'once1');
    });
  });
}
