import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_event.dart';
import 'package:flutter_test/flutter_test.dart';

TransactionEntity _transaction(String id) => TransactionEntity(
      id: id,
      title: 'Tx',
      amount: 10,
      date: DateTime(2024, 1, 1),
      type: TransactionType.expense,
    );

void main() {
  test('TransactionsAdded equality depends on entity', () {
    final a = TransactionsAdded(_transaction('1'));
    final b = TransactionsAdded(_transaction('1'));
    expect(a, equals(b));
  });

  test('TransactionsUpdated equality depends on entity', () {
    final a = TransactionsUpdated(_transaction('1'));
    final b = TransactionsUpdated(_transaction('1'));
    expect(a, equals(b));
  });

  test('TransactionsDeleteRequested equality depends on entity', () {
    final a = TransactionsDeleteRequested(_transaction('1'));
    final b = TransactionsDeleteRequested(_transaction('1'));
    expect(a, equals(b));
  });

  test('TransactionsDeleteUndoRequested has empty props', () {
    const event = TransactionsDeleteUndoRequested();
    expect(event.props, isEmpty);
  });

  test('TransactionsDeleted stores id', () {
    const event = TransactionsDeleted('id');
    expect(event.props.single, 'id');
  });

  test('TransactionsStreamChanged carries items list', () {
    final items = [_transaction('1')];
    final event = TransactionsStreamChanged(items);
    expect(event.props.single, items);
  });

  test('TransactionsStreamFailed stores message', () {
    const event = TransactionsStreamFailed('oops');
    expect(event.props.single, 'oops');
  });
}
