import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_effect.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BudgetShowErrorEffect stores message', () {
    const effect = BudgetShowErrorEffect('error');
    expect(effect.message, 'error');
  });

  test('BudgetShowDialogAddEffect optionally carries budget', () {
    final budget = BudgetEntity(
      id: 'id',
      category: 'Food',
      categoryId: 'food',
      limitAmount: 100,
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 1, 31),
    );
    final effectWithBudget = BudgetShowDialogAddEffect(budget: budget);
    final effectWithoutBudget = BudgetShowDialogAddEffect();

    expect(effectWithBudget.budget, budget);
    expect(effectWithoutBudget.budget, isNull);
  });
}
