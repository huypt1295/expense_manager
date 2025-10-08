import 'package:expense_manager/features/budget/domain/entities/budget_progress.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BudgetProgress equality compares all fields', () {
    final a = BudgetProgress(
      budgetId: 'id',
      spentAmount: 100,
      remainingAmount: 50,
      percentage: 0.5,
    );
    final b = BudgetProgress(
      budgetId: 'id',
      spentAmount: 100,
      remainingAmount: 50,
      percentage: 0.5,
    );

    expect(a, equals(b));
  });

  test('BudgetProgress toJson exposes fields', () {
    final progress = BudgetProgress(
      budgetId: 'id',
      spentAmount: 100,
      remainingAmount: 50,
      percentage: 0.5,
    );

    final json = progress.toJson();
    expect(json['budgetId'], 'id');
    expect(json['percentage'], 0.5);
  });
}
