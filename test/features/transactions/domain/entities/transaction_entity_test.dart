import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TransactionEntity entity() => TransactionEntity(
    id: 'id',
    title: 'Title',
    amount: 10,
    date: DateTime(2024, 1, 1),
    type: TransactionType.expense,
    category: 'Food',
    note: 'Note',
    categoryIcon: '🍔',
  );

  test('TransactionEntity equality compares fields', () {
    expect(entity(), equals(entity()));
  });

  test('TransactionEntity copyWith updates fields', () {
    final updated = entity().copyWith(
      title: 'New',
      amount: 20,
      note: 'Updated',
      categoryIcon: '🍣',
    );

    expect(updated.title, 'New');
    expect(updated.amount, 20);
    expect(updated.note, 'Updated');
    expect(updated.categoryIcon, '🍣');
  });

  test('TransactionEntity toJson outputs expected map', () {
    final json = entity().toJson();
    expect(json['title'], 'Title');
    expect(json['amount'], 10);
    expect(json['category'], 'Food');
    expect(json['categoryIcon'], '🍔');
  });
}
