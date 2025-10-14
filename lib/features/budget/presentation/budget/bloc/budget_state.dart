import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_manager/features/budget/domain/entities/budget_progress.dart';
import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter_core/flutter_core.dart';

class BudgetState extends BaseBlocState with EquatableMixin {
  const BudgetState({
    this.budgets = const <BudgetEntity>[],
    this.progress = const <String, BudgetProgress>{},
    this.transactions = const <TransactionEntity>[],
    this.isLoading = false,
    this.errorMessage,
    this.categories = const <CategoryEntity>[],
    this.areCategoriesLoading = false,
    this.categoriesError,
  });

  final List<BudgetEntity> budgets;
  final Map<String, BudgetProgress> progress;
  final List<TransactionEntity> transactions;
  final bool isLoading;
  final String? errorMessage;
  final List<CategoryEntity> categories;
  final bool areCategoriesLoading;
  final String? categoriesError;

  BudgetState copyWith({
    List<BudgetEntity>? budgets,
    Map<String, BudgetProgress>? progress,
    List<TransactionEntity>? transactions,
    bool? isLoading,
    bool clearError = false,
    String? errorMessage,
    List<CategoryEntity>? categories,
    bool? areCategoriesLoading,
    bool clearCategoriesError = false,
    String? categoriesError,
  }) {
    return BudgetState(
      budgets: budgets ?? this.budgets,
      progress: progress ?? this.progress,
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      categories: categories ?? this.categories,
      areCategoriesLoading: areCategoriesLoading ?? this.areCategoriesLoading,
      categoriesError: clearCategoriesError
          ? null
          : (categoriesError ?? this.categoriesError),
    );
  }

  @override
  List<Object?> get props => <Object?>[
    budgets,
    progress,
    transactions,
    isLoading,
    errorMessage,
    categories,
    areCategoriesLoading,
    categoriesError,
  ];
}
