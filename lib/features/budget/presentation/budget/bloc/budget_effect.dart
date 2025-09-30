import 'package:flutter_core/flutter_core.dart';

sealed class BudgetEffect extends Effect {
  const BudgetEffect();
}

class BudgetShowErrorEffect extends BudgetEffect {
  const BudgetShowErrorEffect(this.message);

  final String message;
}
