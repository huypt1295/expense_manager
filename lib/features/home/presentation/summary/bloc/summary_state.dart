import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter_core/flutter_core.dart';

class SummaryState extends BaseBlocState with EquatableMixin {
  const SummaryState({
    this.greeting = 'Guest',
    this.monthTotal = 0,
    this.recentTransactions = const <TransactionEntity>[],
    this.isLoading = false,
    this.errorMessage,
  });

  final String greeting;
  final double monthTotal;
  final List<TransactionEntity> recentTransactions;
  final bool isLoading;
  final String? errorMessage;

  SummaryState copyWith({
    String? greeting,
    double? monthTotal,
    List<TransactionEntity>? recentTransactions,
    bool? isLoading,
    bool clearError = false,
    String? errorMessage,
  }) {
    return SummaryState(
      greeting: greeting ?? this.greeting,
      monthTotal: monthTotal ?? this.monthTotal,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => <Object?>[
        greeting,
        monthTotal,
        recentTransactions,
        isLoading,
        errorMessage,
      ];
}
