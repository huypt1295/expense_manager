import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/categories/domain/repositories/category_repository.dart';
import 'package:flutter_core/flutter_core.dart';

class UpdateUserCategoryParams {
  const UpdateUserCategoryParams(this.entity);

  final CategoryEntity entity;
}

@injectable
class UpdateUserCategoryUseCase
    extends BaseUseCase<UpdateUserCategoryParams, void> {
  UpdateUserCategoryUseCase(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Result<void>> call(UpdateUserCategoryParams params) {
    return Result.guard<void>(
      () => _repository.updateUserCategory(params.entity),
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
