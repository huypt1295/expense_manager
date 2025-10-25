import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/categories/domain/repositories/category_repository.dart';
import 'package:flutter_core/flutter_core.dart';

class CreateUserCategoryParams {
  const CreateUserCategoryParams(this.entity);

  final CategoryEntity entity;
}

@injectable
class CreateUserCategoryUseCase
    extends BaseUseCase<CreateUserCategoryParams, CategoryEntity> {
  CreateUserCategoryUseCase(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Result<CategoryEntity>> call(CreateUserCategoryParams params) {
    return Result.guard<CategoryEntity>(
      () => _repository.createUserCategory(params.entity),
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
