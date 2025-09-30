import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_manager/features/budget/domain/repositories/budget_repository.dart';
import 'package:flutter_core/flutter_core.dart';

@singleton
class WatchBudgetsUseCase {
  WatchBudgetsUseCase(this._repository);

  final BudgetRepository _repository;

  Stream<List<BudgetEntity>> call(NoParam params) {
    return _repository.watchAll();
  }
}
