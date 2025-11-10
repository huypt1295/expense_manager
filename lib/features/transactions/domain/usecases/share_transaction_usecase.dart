import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:expense_manager/features/transactions/domain/usecases/transactions_failure_mapper.dart';
import 'package:flutter_core/flutter_core.dart';

class ShareTransactionParams {
  const ShareTransactionParams({
    required this.entity,
    required this.targetWorkspaceId,
  });

  final TransactionEntity entity;
  final String targetWorkspaceId;
}

@injectable
class ShareTransactionUseCase
    extends BaseUseCase<ShareTransactionParams, void> {
  ShareTransactionUseCase(this._repository);

  final TransactionsRepository _repository;

  @override
  Future<Result<void>> call(ShareTransactionParams params) {
    return Result.guard<void>(
      () => _repository.shareToWorkspace(
        entity: params.entity,
        workspaceId: params.targetWorkspaceId,
      ),
      mapTransactionsError,
    );
  }
}

