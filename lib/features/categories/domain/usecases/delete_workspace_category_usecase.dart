import 'package:expense_manager/features/categories/domain/repositories/category_repository.dart';
import 'package:flutter_core/flutter_core.dart';

class DeleteWorkspaceCategoryParams {
  const DeleteWorkspaceCategoryParams(this.id);

  final String id;
}

@injectable
class DeleteWorkspaceCategoryUseCase
    extends BaseUseCase<DeleteWorkspaceCategoryParams, void> {
  DeleteWorkspaceCategoryUseCase(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Result<void>> call(DeleteWorkspaceCategoryParams params) {
    return Result.guard<void>(
      () => _repository.deleteWorkspaceCategory(params.id),
      _mapToFailure,
    );
  }
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
