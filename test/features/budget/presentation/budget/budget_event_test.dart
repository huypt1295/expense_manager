import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_event.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter_test/flutter_test.dart';

BudgetEntity _budget(String id) => BudgetEntity(
      id: id,
      category: 'Category',
      categoryId: 'category',
      limitAmount: 100,
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 1, 31),
    );

TransactionEntity _transaction(String id) => TransactionEntity(
      id: id,
      title: 'Tx',
      amount: 10,
      date: DateTime(2024, 1, 1),
    );

void main() {
  test('BudgetShowDialogAdd includes optional budget in props', () {
    final event = BudgetShowDialogAdd(budget: _budget('1'));
    expect(event.props, contains(_budget('1')));
  });

  test('BudgetAdded equality depends on entity', () {
    final a = BudgetAdded(_budget('a'));
    final b = BudgetAdded(_budget('a'));
    expect(a, equals(b));
  });

  test('BudgetUpdated equality depends on entity', () {
    final a = BudgetUpdated(_budget('u'));
    final b = BudgetUpdated(_budget('u'));
    expect(a, equals(b));
  });

  test('BudgetDeleted stores id in props', () {
    const event = BudgetDeleted('delete');
    expect(event.props.single, 'delete');
  });

  test('BudgetStreamUpdated carries budgets list', () {
    final budgets = [_budget('a')];
    final event = BudgetStreamUpdated(budgets);
    expect(event.props.single, budgets);
  });

  test('BudgetTransactionsUpdated carries transactions list', () {
    final transactions = [_transaction('t')];
    final event = BudgetTransactionsUpdated(transactions);
    expect(event.props.single, transactions);
  });

  test('BudgetStreamFailed stores message', () {
    const event = BudgetStreamFailed('error');
    expect(event.props.single, 'error');
  });
}
