import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:expense_manager/features/transactions/domain/usecases/transactions_failure_mapper.dart';
import 'package:flutter_core/flutter_core.dart';

@injectable
class GetTransactionsOnceUseCase
    extends BaseUseCase<NoParam, List<TransactionEntity>> {
  GetTransactionsOnceUseCase(this._repository);

  final TransactionsRepository _repository;

  @override
  Future<Result<List<TransactionEntity>>> call(NoParam params) {
    return Result.guard<List<TransactionEntity>>(
      _repository.getAllOnce,
      mapTransactionsError,
    );
  }
}
