import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_manager/features/budget/domain/repositories/budget_repository.dart';
import 'package:expense_manager/features/budget/domain/usecases/budget_failure_mapper.dart';
import 'package:flutter_core/flutter_core.dart';

class UpdateBudgetParams {
  const UpdateBudgetParams(this.entity);

  final BudgetEntity entity;
}

@injectable
class UpdateBudgetUseCase extends BaseUseCase<UpdateBudgetParams, void> {
  UpdateBudgetUseCase(this._repository);

  final BudgetRepository _repository;

  @override
  Future<Result<void>> call(UpdateBudgetParams params) {
    return Result.guard<void>(
      () => _repository.update(params.entity),
      mapBudgetError,
    );
  }
}
