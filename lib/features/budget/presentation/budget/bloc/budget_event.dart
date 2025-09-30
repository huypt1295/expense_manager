import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter_core/flutter_core.dart';

abstract class BudgetEvent extends BaseBlocEvent with EquatableMixin {
  const BudgetEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class BudgetStarted extends BudgetEvent {
  const BudgetStarted();
}

class BudgetAdded extends BudgetEvent {
  const BudgetAdded(this.entity);

  final BudgetEntity entity;

  @override
  List<Object?> get props => <Object?>[entity];
}

class BudgetUpdated extends BudgetEvent {
  const BudgetUpdated(this.entity);

  final BudgetEntity entity;

  @override
  List<Object?> get props => <Object?>[entity];
}

class BudgetDeleted extends BudgetEvent {
  const BudgetDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => <Object?>[id];
}

class BudgetStreamUpdated extends BudgetEvent {
  const BudgetStreamUpdated(this.budgets);

  final List<BudgetEntity> budgets;

  @override
  List<Object?> get props => <Object?>[budgets];
}

class BudgetTransactionsUpdated extends BudgetEvent {
  const BudgetTransactionsUpdated(this.transactions);

  final List<TransactionEntity> transactions;

  @override
  List<Object?> get props => <Object?>[transactions];
}

class BudgetStreamFailed extends BudgetEvent {
  const BudgetStreamFailed(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
