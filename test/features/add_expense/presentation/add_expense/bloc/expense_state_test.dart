import 'package:expense_manager/features/add_expense/presentation/add_expense/bloc/expense_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ExpenseFormError stores message in props', () {
    const state = ExpenseFormError('error');
    expect(state.props.single, 'error');
  });

  test('ExpenseFormData copyWith overrides selected fields', () {
    final initial = ExpenseFormData(date: DateTime(2024, 1, 1));
    final updated = initial.copyWith(
      title: 'Title',
      amount: 10,
      category: 'Food',
      description: 'Desc',
      date: DateTime(2024, 2, 1),
    );

    expect(updated.title, 'Title');
    expect(updated.amount, 10);
    expect(updated.category, 'Food');
    expect(updated.description, 'Desc');
    expect(updated.date, DateTime(2024, 2, 1));
  });
}
