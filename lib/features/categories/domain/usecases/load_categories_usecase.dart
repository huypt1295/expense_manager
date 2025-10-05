import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/categories/domain/repositories/category_repository.dart';
import 'package:flutter_core/flutter_core.dart';

@singleton
class LoadCategoriesUseCase extends BaseUseCase<NoParam, List<CategoryEntity>> {
  LoadCategoriesUseCase(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Result<List<CategoryEntity>>> call(NoParam params) {
    return Result.guard<List<CategoryEntity>>(
      _repository.fetchAll,
      _mapToFailure,
    );
  }

  Failure _mapToFailure(Object error, StackTrace stackTrace) {
    if (error is Failure) {
      return error;
    }
    return UnknownFailure(
      message: error.toString(),
      cause: error,
      stackTrace: stackTrace,
    );
  }
}
