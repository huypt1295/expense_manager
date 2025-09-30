import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:expense_manager/features/transactions/domain/usecases/transactions_failure_mapper.dart';
import 'package:flutter_core/flutter_core.dart';

class UpdateTransactionParams {
  const UpdateTransactionParams(this.entity);

  final TransactionEntity entity;
}

@injectable
class UpdateTransactionUseCase
    extends BaseUseCase<UpdateTransactionParams, void> {
  UpdateTransactionUseCase(this._repository);

  final TransactionsRepository _repository;

  @override
  Future<Result<void>> call(UpdateTransactionParams params) {
    return Result.guard<void>(
      () => _repository.update(params.entity),
      mapTransactionsError,
    );
  }
}
