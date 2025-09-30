import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter_core/flutter_core.dart';

abstract class SummaryEvent extends BaseBlocEvent with EquatableMixin {
  const SummaryEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class SummaryStarted extends SummaryEvent {
  const SummaryStarted();
}

class SummaryUserChanged extends SummaryEvent {
  const SummaryUserChanged(this.snapshot);

  final CurrentUserSnapshot? snapshot;

  @override
  List<Object?> get props => <Object?>[snapshot];
}

class SummaryTransactionsUpdated extends SummaryEvent {
  const SummaryTransactionsUpdated(this.transactions);

  final List<TransactionEntity> transactions;

  @override
  List<Object?> get props => <Object?>[transactions];
}

class SummaryStreamFailed extends SummaryEvent {
  const SummaryStreamFailed(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
