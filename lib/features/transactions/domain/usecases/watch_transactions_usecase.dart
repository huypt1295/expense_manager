import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:flutter_core/flutter_core.dart';

@singleton
class WatchTransactionsUseCase {
  WatchTransactionsUseCase(this._repository);

  final TransactionsRepository _repository;

  Stream<List<TransactionEntity>> call(NoParam params) {
    return _repository.watchAll();
  }
}
