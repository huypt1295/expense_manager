import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/transactions/data/models/transaction_model.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TransactionModel model() => TransactionModel(
    id: 'tx',
    title: 'Coffee',
    amount: 12.5,
    date: DateTime(2024, 1, 1),
    type: TransactionType.expense,
    category: 'Food',
    note: 'note',
    categoryIcon: '🍔',
  );

  test('toEntity converts to domain entity', () {
    final entity = model().toEntity();
    expect(entity.title, 'Coffee');
    expect(entity.amount, 12.5);
    expect(entity.category, 'Food');
    expect(entity.categoryIcon, '🍔');
  });

  test('fromEntity creates model with same data', () {
    final entity = TransactionEntity(
      id: 'tx',
      title: 'Dinner',
      amount: 30,
      date: DateTime(2024, 2, 2),
      type: TransactionType.expense,
      category: 'Travel',
      note: 'note',
      categoryIcon: '🍔',
    );

    final model = TransactionModel.fromEntity(entity);
    expect(model.id, 'tx');
    expect(model.title, 'Dinner');
    expect(model.amount, 30);
  });

  test('toFirestore outputs expected map', () {
    final map = model().toFirestore();
    expect(map['title'], 'Coffee');
    expect(map['amount'], 12.5);
    expect(map['date'], isA<Timestamp>());
    expect(map['deleted'], isFalse);
    expect(map['categoryIcon'], '🍔');
  });

  test('fromFirestore reads Firestore snapshot', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore
        .collection('users')
        .doc('uid')
        .collection('transactions')
        .doc('doc')
        .set({
          'title': 'Snack',
          'amount': 5,
          'date': Timestamp.fromDate(DateTime(2024, 3, 1)),
          'deleted': false,
          'category': 'Food',
          'note': 'chips',
          'type': 'expense',
          'categoryIcon': '🍔',
        });

    final snapshot = await firestore
        .collection('users')
        .doc('uid')
        .collection('transactions')
        .doc('doc')
        .get();

    final model = TransactionModel.fromFirestore(snapshot);
    expect(model.id, 'doc');
    expect(model.title, 'Snack');
    expect(model.deleted, isFalse);
    expect(model.categoryIcon, '🍔');
  });
}
