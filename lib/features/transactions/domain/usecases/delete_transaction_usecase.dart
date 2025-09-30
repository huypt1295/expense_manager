import 'package:expense_manager/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:expense_manager/features/transactions/domain/usecases/transactions_failure_mapper.dart';
import 'package:flutter_core/flutter_core.dart';

class DeleteTransactionParams {
  const DeleteTransactionParams(this.id);

  final String id;
}

@injectable
class DeleteTransactionUseCase
    extends BaseUseCase<DeleteTransactionParams, void> {
  DeleteTransactionUseCase(this._repository);

  final TransactionsRepository _repository;

  @override
  Future<Result<void>> call(DeleteTransactionParams params) {
    return Result.guard<void>(
      () => _repository.deleteById(params.id),
      mapTransactionsError,
    );
  }
}
