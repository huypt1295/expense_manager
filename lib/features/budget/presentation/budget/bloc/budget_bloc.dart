import 'dart:async';
import 'dart:math';

import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_manager/features/budget/domain/entities/budget_progress.dart';
import 'package:expense_manager/features/budget/domain/usecases/add_budget_usecase.dart';
import 'package:expense_manager/features/budget/domain/usecases/budget_failure_mapper.dart';
import 'package:expense_manager/features/budget/domain/usecases/delete_budget_usecase.dart';
import 'package:expense_manager/features/budget/domain/usecases/update_budget_usecase.dart';
import 'package:expense_manager/features/budget/domain/usecases/watch_budgets_usecase.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_effect.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_event.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_state.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/domain/usecases/watch_transactions_usecase.dart';
import 'package:expense_manager/features/transactions/domain/usecases/transactions_failure_mapper.dart';
import 'package:flutter_core/flutter_core.dart';

@injectable
class BudgetBloc extends BaseBloc<BudgetEvent, BudgetState, BudgetEffect> {
  BudgetBloc(
    this._watchBudgetsUseCase,
    this._addBudgetUseCase,
    this._updateBudgetUseCase,
    this._deleteBudgetUseCase,
    this._watchTransactionsUseCase,
  ) : super(const BudgetState()) {
    on<BudgetStarted>(_onStarted);
    on<BudgetShowDialogAdd>(_showDialogAddBudget);
    on<BudgetStreamUpdated>(_onBudgetsUpdated);
    on<BudgetTransactionsUpdated>(_onTransactionsUpdated);
    on<BudgetStreamFailed>(_onStreamFailed);
    on<BudgetAdded>(_onAdded);
    on<BudgetUpdated>(_onUpdated);
    on<BudgetDeleted>(_onDeleted);
  }

  final WatchBudgetsUseCase _watchBudgetsUseCase;
  final AddBudgetUseCase _addBudgetUseCase;
  final UpdateBudgetUseCase _updateBudgetUseCase;
  final DeleteBudgetUseCase _deleteBudgetUseCase;
  final WatchTransactionsUseCase _watchTransactionsUseCase;

  StreamSubscription<List<BudgetEntity>>? _budgetsSubscription;
  StreamSubscription<List<TransactionEntity>>? _transactionsSubscription;
  List<BudgetEntity> _budgets = const <BudgetEntity>[];
  List<TransactionEntity> _transactions = const <TransactionEntity>[];

  Future<void> _onStarted(
    BudgetStarted event,
    Emitter<BudgetState> emit,
  ) async {
    if (_budgetsSubscription != null && _transactionsSubscription != null) {
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      _budgetsSubscription ??= _watchBudgetsUseCase(NoParam()).listen(
        (budgets) => add(BudgetStreamUpdated(budgets)),
        onError: (Object error, StackTrace stackTrace) {
          final failure = mapBudgetError(error, stackTrace);
          add(BudgetStreamFailed(failure.message ?? failure.code));
        },
      );
    } catch (error, stackTrace) {
      final failure = mapBudgetError(error, stackTrace);
      emit(_errorState(failure.message ?? failure.code));
      emitEffect(BudgetShowErrorEffect(failure.message ?? failure.code));
    }

    try {
      _transactionsSubscription ??= _watchTransactionsUseCase(NoParam()).listen(
        (transactions) => add(BudgetTransactionsUpdated(transactions)),
        onError: (Object error, StackTrace stackTrace) {
          final failure = mapTransactionsError(error, stackTrace);
          add(BudgetStreamFailed(failure.message ?? failure.code));
        },
      );
    } catch (error, stackTrace) {
      final failure = mapTransactionsError(error, stackTrace);
      emit(_errorState(failure.message ?? failure.code));
      emitEffect(BudgetShowErrorEffect(failure.message ?? failure.code));
    }
  }

  void _showDialogAddBudget(
    BudgetShowDialogAdd event,
    Emitter<BudgetState> emit,
  ) {
    emitEffect(BudgetShowDialogAddEffect(budget: event.budget));
  }

  void _onBudgetsUpdated(
    BudgetStreamUpdated event,
    Emitter<BudgetState> emit,
  ) {
    _budgets = event.budgets;
    _refreshState(emit);
  }

  void _onTransactionsUpdated(
    BudgetTransactionsUpdated event,
    Emitter<BudgetState> emit,
  ) {
    _transactions = event.transactions;
    _refreshState(emit);
  }

  void _onStreamFailed(
    BudgetStreamFailed event,
    Emitter<BudgetState> emit,
  ) {
    emit(_errorState(event.message));
    emitEffect(BudgetShowErrorEffect(event.message));
  }

  Future<void> _onAdded(
    BudgetAdded event,
    Emitter<BudgetState> emit,
  ) async {
    await runResult<void>(
      emit: emit,
      task: () => _addBudgetUseCase(AddBudgetParams(event.entity)),
      onStart: (state) => state.copyWith(isLoading: true, clearError: true),
      onOk: (state, _) => state.copyWith(isLoading: false),
      onErr: (currentState, failure) {
        final message = failure.message ?? failure.code;
        emitEffect(BudgetShowErrorEffect(message));
        emit(currentState.copyWith(isLoading: false, errorMessage: message));
      },
      trackKey: 'budget.add',
      spanName: 'budget.add',
    );
  }

  Future<void> _onUpdated(
    BudgetUpdated event,
    Emitter<BudgetState> emit,
  ) async {
    await runResult<void>(
      emit: emit,
      task: () => _updateBudgetUseCase(UpdateBudgetParams(event.entity)),
      onStart: (state) => state.copyWith(isLoading: true, clearError: true),
      onOk: (state, _) => state.copyWith(isLoading: false),
      onErr: (currentState, failure) {
        final message = failure.message ?? failure.code;
        emitEffect(BudgetShowErrorEffect(message));
        emit(currentState.copyWith(isLoading: false, errorMessage: message));
      },
      trackKey: 'budget.update',
      spanName: 'budget.update',
    );
  }

  Future<void> _onDeleted(
    BudgetDeleted event,
    Emitter<BudgetState> emit,
  ) async {
    await runResult<void>(
      emit: emit,
      task: () => _deleteBudgetUseCase(DeleteBudgetParams(event.id)),
      onStart: (state) => state.copyWith(isLoading: true, clearError: true),
      onOk: (state, _) => state.copyWith(isLoading: false),
      onErr: (currentState, failure) {
        final message = failure.message ?? failure.code;
        emitEffect(BudgetShowErrorEffect(message));
        emit(currentState.copyWith(isLoading: false, errorMessage: message));
      },
      trackKey: 'budget.delete',
      spanName: 'budget.delete',
    );
  }

  void _refreshState(Emitter<BudgetState> emit) {
    final progress = _computeProgress(_budgets, _transactions);
    emit(
      state.copyWith(
        budgets: List<BudgetEntity>.unmodifiable(_budgets),
        progress: progress,
        isLoading: false,
        clearError: true,
      ),
    );
  }

  Map<String, BudgetProgress> _computeProgress(
    List<BudgetEntity> budgets,
    List<TransactionEntity> transactions,
  ) {
    final result = <String, BudgetProgress>{};
    for (final budget in budgets) {
      final double spent = transactions
          .where((transaction) => _matchesBudget(transaction, budget))
          .fold<double>(0, (sum, tx) => sum + max(tx.amount, 0.0));
      final double remaining = budget.limitAmount - spent;
      final double percentage =
          budget.limitAmount <= 0 ? 0 : spent / budget.limitAmount;

      result[budget.id] = BudgetProgress(
        budgetId: budget.id,
        spentAmount: spent,
        remainingAmount: remaining,
        percentage: percentage,
      );
    }
    return result;
  }

  bool _matchesBudget(TransactionEntity transaction, BudgetEntity budget) {
    final category = (transaction.category ?? '').toLowerCase().trim();
    final budgetCategory = budget.category.toLowerCase().trim();
    final budgetCategoryId = budget.categoryId.toLowerCase().trim();
    final inCategory = category == budgetCategory ||
        (budgetCategoryId.isNotEmpty && category == budgetCategoryId);
    final inRange = !transaction.date.isBefore(budget.startDate) &&
        !transaction.date.isAfter(budget.endDate);
    return inCategory && inRange;
  }

  BudgetState _errorState(String message) {
    return state.copyWith(isLoading: false, errorMessage: message);
  }

  @override
  Future<void> close() async {
    await _budgetsSubscription?.cancel();
    await _transactionsSubscription?.cancel();
    return super.close();
  }
}
