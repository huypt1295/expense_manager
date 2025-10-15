import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter_core/flutter_core.dart';

class SummaryState extends BaseBlocState with EquatableMixin {
  const SummaryState({
    this.greeting = 'Guest',
    this.monthlyIncome = 0,
    this.monthlyExpense = 0,
    this.monthlyRemaining = 0,
    this.weeklyExpenses = const <SummaryDailySpending>[],
    this.recentTransactions = const <TransactionEntity>[],
    this.isLoading = false,
    this.errorMessage,
  });

  final String greeting;
  final double monthlyIncome;
  final double monthlyExpense;
  final double monthlyRemaining;
  final List<SummaryDailySpending> weeklyExpenses;
  final List<TransactionEntity> recentTransactions;
  final bool isLoading;
  final String? errorMessage;

  SummaryState copyWith({
    String? greeting,
    double? monthlyIncome,
    double? monthlyExpense,
    double? monthlyRemaining,
    List<SummaryDailySpending>? weeklyExpenses,
    List<TransactionEntity>? recentTransactions,
    bool? isLoading,
    bool clearError = false,
    String? errorMessage,
  }) {
    return SummaryState(
      greeting: greeting ?? this.greeting,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlyExpense: monthlyExpense ?? this.monthlyExpense,
      monthlyRemaining: monthlyRemaining ?? this.monthlyRemaining,
      weeklyExpenses: weeklyExpenses ?? this.weeklyExpenses,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => <Object?>[
    greeting,
    monthlyIncome,
    monthlyExpense,
    monthlyRemaining,
    weeklyExpenses,
    recentTransactions,
    isLoading,
    errorMessage,
  ];
}

class SummaryDailySpending with EquatableMixin {
  const SummaryDailySpending({required this.date, required this.amount});

  final DateTime date;
  final double amount;

  @override
  List<Object?> get props => <Object?>[date, amount];
}
