import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/categories/domain/repositories/category_repository.dart';
import 'package:flutter_core/flutter_core.dart';

class UpdateWorkspaceCategoryParams {
  const UpdateWorkspaceCategoryParams(this.entity);

  final CategoryEntity entity;
}

@injectable
class UpdateWorkspaceCategoryUseCase
    extends BaseUseCase<UpdateWorkspaceCategoryParams, void> {
  UpdateWorkspaceCategoryUseCase(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Result<void>> call(UpdateWorkspaceCategoryParams params) {
    return Result.guard<void>(
      () => _repository.updateWorkspaceCategory(params.entity),
      _mapToFailure,
    );
  }
}

Failure _mapToFailure(Object error, StackTrace stackTrace) {
  if (error is Failure) {
    return error;
  }
  if (error is ArgumentError) {
    return ValidationFailure(
      message: error.message?.toString() ?? 'Invalid category data',
    );
  }
  return UnknownFailure(
    message: error.toString(),
    cause: error,
    stackTrace: stackTrace,
  );
}
