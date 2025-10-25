import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter_core/flutter_core.dart';

/// Events
abstract class AddTransactionEvent extends BaseBlocEvent with EquatableMixin {
  const AddTransactionEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class AddTransactionInitEvent extends AddTransactionEvent {
  const AddTransactionInitEvent({this.forceRefresh = false});

  final bool forceRefresh;

  @override
  List<Object?> get props => <Object?>[forceRefresh];
}

class CategoriesStreamUpdatedEvent extends AddTransactionEvent {
  const CategoriesStreamUpdatedEvent(this.categories);

  final List<CategoryEntity> categories;

  @override
  List<Object?> get props => <Object?>[categories];
}

class CategoriesStreamFailedEvent extends AddTransactionEvent {
  const CategoriesStreamFailedEvent(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
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
