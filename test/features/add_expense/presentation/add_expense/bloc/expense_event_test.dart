import 'package:expense_manager/features/add_expense/presentation/add_expense/bloc/expense_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ExpenseFormSubmitted stores all form values', () {
    final event = ExpenseFormSubmitted(
      title: 'Title',
      amount: 50,
      category: 'Food',
      description: 'Desc',
      date: DateTime(2024, 1, 1),
    );

    expect(event.props[0], 'Title');
    expect(event.props[1], 50);
    expect(event.props[2], 'Food');
    expect(event.props[3], 'Desc');
  });

  test('reset and close events are constant', () {
    expect(const ExpenseFormReset(), const ExpenseFormReset());
    expect(const ExpenseFormClosed(), const ExpenseFormClosed());
  });
}
