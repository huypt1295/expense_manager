import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_manager/features/budget/domain/repositories/budget_repository.dart';
import 'package:expense_manager/features/budget/domain/usecases/budget_failure_mapper.dart';
import 'package:flutter_core/flutter_core.dart';

class AddBudgetParams {
  const AddBudgetParams(this.entity);

  final BudgetEntity entity;
}

@injectable
class AddBudgetUseCase extends BaseUseCase<AddBudgetParams, void> {
  AddBudgetUseCase(this._repository);

  final BudgetRepository _repository;

  @override
  Future<Result<void>> call(AddBudgetParams params) {
    return Result.guard<void>(
      () => _repository.add(params.entity),
      mapBudgetError,
    );
  }
}
