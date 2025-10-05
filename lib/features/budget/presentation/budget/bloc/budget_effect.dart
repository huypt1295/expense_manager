import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:flutter_core/flutter_core.dart';

sealed class BudgetEffect extends Effect {
  const BudgetEffect();
}

class BudgetShowErrorEffect extends BudgetEffect {
  const BudgetShowErrorEffect(this.message);

  final String message;
}

class BudgetShowDialogAddEffect extends BudgetEffect {
  BudgetShowDialogAddEffect({this.budget});

  final BudgetEntity? budget;
}
