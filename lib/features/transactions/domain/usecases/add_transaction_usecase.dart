import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:expense_manager/features/transactions/domain/usecases/transactions_failure_mapper.dart';
import 'package:flutter_core/flutter_core.dart';

class AddTransactionParams {
  const AddTransactionParams(this.entity);

  final TransactionEntity entity;
}

@injectable
class AddTransactionUseCase extends BaseUseCase<AddTransactionParams, void> {
  AddTransactionUseCase(this._repository);

  final TransactionsRepository _repository;

  @override
  Future<Result<void>> call(AddTransactionParams params) {
    return Result.guard<void>(
      () => _repository.add(params.entity),
      mapTransactionsError,
    );
  }
}
