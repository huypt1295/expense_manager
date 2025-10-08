import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/features/home/presentation/summary/bloc/summary_event.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter_test/flutter_test.dart';

TransactionEntity _transaction(String id) => TransactionEntity(
      id: id,
      title: 'Tx',
      amount: 10,
      date: DateTime(2024, 1, 1),
    );

void main() {
  test('SummaryUserChanged exposes snapshot', () {
    const snapshot = CurrentUserSnapshot(uid: 'uid');
    const event = SummaryUserChanged(snapshot);
    expect(event.props.single, snapshot);
  });

  test('SummaryTransactionsUpdated exposes transactions list', () {
    final transactions = [_transaction('1')];
    final event = SummaryTransactionsUpdated(transactions);
    expect(event.props.single, transactions);
  });

  test('SummaryStreamFailed keeps message', () {
    const event = SummaryStreamFailed('fail');
    expect(event.props.single, 'fail');
  });
}
