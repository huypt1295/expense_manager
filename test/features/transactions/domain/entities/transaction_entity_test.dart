import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TransactionEntity entity() => TransactionEntity(
        id: 'id',
        title: 'Title',
        amount: 10,
        date: DateTime(2024, 1, 1),
        category: 'Food',
        note: 'Note',
      );

  test('TransactionEntity equality compares fields', () {
    expect(entity(), equals(entity()));
  });

  test('TransactionEntity copyWith updates fields', () {
    final updated = entity().copyWith(
      title: 'New',
      amount: 20,
      note: 'Updated',
    );

    expect(updated.title, 'New');
    expect(updated.amount, 20);
    expect(updated.note, 'Updated');
  });

  test('TransactionEntity toJson outputs expected map', () {
    final json = entity().toJson();
    expect(json['title'], 'Title');
    expect(json['amount'], 10);
    expect(json['category'], 'Food');
  });
}
