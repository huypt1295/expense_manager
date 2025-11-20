import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter_core/flutter_core.dart';

abstract class TransactionsRepository extends Repository {
  Stream<List<TransactionEntity>> watchAll();

  Future<List<TransactionEntity>> getAllOnce();

  Future<void> add(TransactionEntity entity);

  Future<void> update(TransactionEntity entity);

  Future<void> deleteById(String id);

  Future<void> shareToWorkspace({
    required TransactionEntity entity,
    required String workspaceId,
  });
}
