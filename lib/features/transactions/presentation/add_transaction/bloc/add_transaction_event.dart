import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter_core/flutter_core.dart';

// Events
abstract class AddTransactionEvent extends BaseBlocEvent with EquatableMixin {
  const AddTransactionEvent();

  @override
  List<Object?> get props => [];
}

class AddTransactionInitEvent extends AddTransactionEvent {
  final bool forceRefresh;

  AddTransactionInitEvent({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class TransactionsAddedEvent extends AddTransactionEvent {
  const TransactionsAddedEvent(this.entity);

  final TransactionEntity entity;

  @override
  List<Object?> get props => <Object?>[entity];
}

class TransactionsUpdatedEvent extends AddTransactionEvent {
  const TransactionsUpdatedEvent(this.entity);

  final TransactionEntity entity;

  @override
  List<Object?> get props => <Object?>[entity];
}