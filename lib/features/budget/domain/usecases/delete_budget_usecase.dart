import 'package:expense_manager/features/budget/domain/repositories/budget_repository.dart';
import 'package:expense_manager/features/budget/domain/usecases/budget_failure_mapper.dart';
import 'package:flutter_core/flutter_core.dart';

class DeleteBudgetParams {
  const DeleteBudgetParams(this.id);

  final String id;
}

@injectable
class DeleteBudgetUseCase extends BaseUseCase<DeleteBudgetParams, void> {
  DeleteBudgetUseCase(this._repository);

  final BudgetRepository _repository;

  @override
  Future<Result<void>> call(DeleteBudgetParams params) {
    return Result.guard<void>(
      () => _repository.deleteById(params.id),
      mapBudgetError,
    );
  }
}
