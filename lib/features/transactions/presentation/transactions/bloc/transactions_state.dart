import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter_core/flutter_core.dart';

class TransactionsState extends BaseBlocState with EquatableMixin {
  const TransactionsState({
    this.items = const <TransactionEntity>[],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<TransactionEntity> items;
  final bool isLoading;
  final String? errorMessage;

  TransactionsState copyWith({
    List<TransactionEntity>? items,
    bool? isLoading,
    bool clearError = false,
    String? errorMessage,
  }) {
    return TransactionsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => <Object?>[items, isLoading, errorMessage];
}
