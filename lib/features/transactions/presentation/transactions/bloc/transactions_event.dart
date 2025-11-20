import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter_core/flutter_core.dart';

abstract class TransactionsEvent extends BaseBlocEvent with EquatableMixin {
  const TransactionsEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class TransactionsStarted extends TransactionsEvent {
  const TransactionsStarted();
}

class TransactionsAdded extends TransactionsEvent {
  const TransactionsAdded(this.entity);

  final TransactionEntity entity;

  @override
  List<Object?> get props => <Object?>[entity];
}

class TransactionsUpdated extends TransactionsEvent {
  const TransactionsUpdated(this.entity);

  final TransactionEntity entity;

  @override
  List<Object?> get props => <Object?>[entity];
}

class TransactionsDeleteRequested extends TransactionsEvent {
  const TransactionsDeleteRequested(this.entity);

  final TransactionEntity entity;

  @override
  List<Object?> get props => <Object?>[entity];
}

class TransactionsDeleteUndoRequested extends TransactionsEvent {
  const TransactionsDeleteUndoRequested();
}


class TransactionsShareRequested extends TransactionsEvent {
  const TransactionsShareRequested({
    required this.entity,
    required this.targetWorkspaceId,
    required this.targetWorkspaceName,
  });

  final TransactionEntity entity;
  final String targetWorkspaceId;
  final String targetWorkspaceName;

  @override
  List<Object?> get props => <Object?>[
        entity,
        targetWorkspaceId,
        targetWorkspaceName,
      ];
}

class TransactionsDeleted extends TransactionsEvent {
  const TransactionsDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => <Object?>[id];
}

class TransactionsStreamChanged extends TransactionsEvent {
  const TransactionsStreamChanged(this.items);

  final List<TransactionEntity> items;

  @override
  List<Object?> get props => <Object?>[items];
}

class TransactionsStreamFailed extends TransactionsEvent {
  const TransactionsStreamFailed(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
