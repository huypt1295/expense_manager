import 'dart:async';
import 'dart:math';

import 'package:expense_manager/core/constants/data_constant.dart';
import 'package:expense_manager/core/workspace/current_workspace.dart';
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
import 'package:expense_manager/features/categories/application/categories_service.dart';
import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
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
    this._categoriesService,
    this._currentWorkspace,
  ) : super(const BudgetState()) {
    on<BudgetStarted>(_onStarted);
    on<BudgetShowDialogAdd>(_showDialogAddBudget);
    on<BudgetStreamUpdated>(_onBudgetsUpdated);
    on<BudgetTransactionsUpdated>(_onTransactionsUpdated);
    on<BudgetStreamFailed>(_onStreamFailed);
    on<BudgetAdded>(_onAdded);
    on<BudgetUpdated>(_onUpdated);
    on<BudgetDeleteRequested>(_onDeleteRequested);
    on<BudgetDeleteUndoRequested>(_onDeleteUndoRequested);
    on<BudgetDeleted>(_onDeleted);
    on<BudgetCategoriesRequested>(_onCategoriesRequested);
  }

  static const String _permissionErrorMessage =
      'You do not have permission to manage budgets in this workspace.';

  final WatchBudgetsUseCase _watchBudgetsUseCase;
  final AddBudgetUseCase _addBudgetUseCase;
  final UpdateBudgetUseCase _updateBudgetUseCase;
  final DeleteBudgetUseCase _deleteBudgetUseCase;
  final WatchTransactionsUseCase _watchTransactionsUseCase;
  final CategoriesService _categoriesService;
  final CurrentWorkspace _currentWorkspace;

  StreamSubscription<List<BudgetEntity>>? _budgetsSubscription;
  StreamSubscription<List<TransactionEntity>>? _transactionsSubscription;
  List<BudgetEntity> _budgets = const <BudgetEntity>[];
  List<TransactionEntity> _transactions = const <TransactionEntity>[];

  _PendingDeletion? _pendingDeletion;
  _PendingDeletion? _committingDeletion;
  Timer? _pendingDeletionTimer;

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
    if (!_shouldAllowManage(emit)) {
      return;
    }
    emitEffect(BudgetShowDialogAddEffect(budget: event.budget));
  }

  void _onBudgetsUpdated(BudgetStreamUpdated event, Emitter<BudgetState> emit) {
    final idsToOmit = <String>{};
    final pending = _pendingDeletion;
    final committing = _committingDeletion;
    if (pending != null) {
      idsToOmit.add(pending.entity.id);
    }
    if (committing != null) {
      idsToOmit.add(committing.entity.id);
    }

    final items = idsToOmit.isEmpty
        ? event.budgets
        : event.budgets.where((item) => !idsToOmit.contains(item.id)).toList();

    _budgets = items;
    _refreshState(emit);
  }

  void _onTransactionsUpdated(
    BudgetTransactionsUpdated event,
    Emitter<BudgetState> emit,
  ) {
    _transactions = event.transactions;
    _refreshState(emit);
  }

  void _onStreamFailed(BudgetStreamFailed event, Emitter<BudgetState> emit) {
    emit(_errorState(event.message));
    emitEffect(BudgetShowErrorEffect(event.message));
  }

  Future<void> _onAdded(BudgetAdded event, Emitter<BudgetState> emit) async {
    if (!_shouldAllowManage(emit)) {
      return;
    }

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
    if (!_shouldAllowManage(emit)) {
      return;
    }

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

  void _onDeleteRequested(
    BudgetDeleteRequested event,
    Emitter<BudgetState> emit,
  ) {
    _commitPendingDeletion();

    if (!_shouldAllowManage(emit)) {
      return;
    }

    final currentItems = state.budgets;
    final index = currentItems.indexWhere((item) => item.id == event.entity.id);
    if (index == -1) {
      return;
    }

    final updatedItems = List<BudgetEntity>.of(currentItems)..removeAt(index);
    emit(state.copyWith(budgets: updatedItems, clearError: true));

    _pendingDeletion = _PendingDeletion(entity: event.entity, index: index);
    _startPendingDeletionTimer();

    emitEffect(
      const BudgetShowUndoDeleteEffect(
        message: 'Budget deleted',
        actionLabel: 'Undo',
        duration: kUndoDuration,
      ),
    );
  }

  void _onDeleteUndoRequested(
    BudgetDeleteUndoRequested event,
    Emitter<BudgetState> emit,
  ) {
    final pending = _pendingDeletion;
    if (pending == null) {
      return;
    }

    _pendingDeletionTimer?.cancel();
    _pendingDeletionTimer = null;
    _pendingDeletion = null;

    final updatedItems = List<BudgetEntity>.of(state.budgets)
      ..removeWhere((item) => item.id == pending.entity.id);
    final insertIndex = pending.index.clamp(0, updatedItems.length);
    updatedItems.insert(insertIndex, pending.entity);

    emit(state.copyWith(budgets: updatedItems, clearError: true));
  }

  void _startPendingDeletionTimer() {
    _pendingDeletionTimer?.cancel();
    _pendingDeletionTimer = Timer(kUndoDuration, _commitPendingDeletion);
  }

  void _commitPendingDeletion() {
    final pending = _pendingDeletion;
    if (pending == null) {
      return;
    }

    _pendingDeletionTimer?.cancel();
    _pendingDeletionTimer = null;
    _pendingDeletion = null;
    _committingDeletion = pending;
    add(BudgetDeleted(pending.entity.id));
  }

  Future<void> _onDeleted(
    BudgetDeleted event,
    Emitter<BudgetState> emit,
  ) async {
    if (!_shouldAllowManage(emit)) {
      final committing = _committingDeletion;
      if (committing != null) {
        final items = List<BudgetEntity>.of(state.budgets)
          ..removeWhere((item) => item.id == committing.entity.id);
        final insertIndex = committing.index.clamp(0, items.length);
        items.insert(insertIndex, committing.entity);
        _committingDeletion = null;

        emit(state.copyWith(budgets: items, clearError: true));
      }
      return;
    }

    await runResult<void>(
      emit: emit,
      task: () => _deleteBudgetUseCase(DeleteBudgetParams(event.id)),
      onStart: (state) => state.copyWith(isLoading: true, clearError: true),
      onOk: (state, _) {
        _committingDeletion = null;
        return state.copyWith(isLoading: false);
      },
      onErr: (currentState, failure) {
        final committing = _committingDeletion;
        final message = failure.message ?? failure.code;

        if (committing != null) {
          final items = List<BudgetEntity>.of(state.budgets)
            ..removeWhere((item) => item.id == committing.entity.id);
          final insertIndex = committing.index.clamp(0, items.length);
          items.insert(insertIndex, committing.entity);
          _committingDeletion = null;

          emit(
            currentState.copyWith(
              budgets: items,
              isLoading: false,
              errorMessage: message,
            ),
          );
        } else {
          emit(currentState.copyWith(isLoading: false, errorMessage: message));
        }

        emitEffect(BudgetShowErrorEffect(message));
      },
      trackKey: 'budget.delete',
      spanName: 'budget.delete',
    );
  }

  Future<void> _onCategoriesRequested(
    BudgetCategoriesRequested event,
    Emitter<BudgetState> emit,
  ) async {
    if (state.areCategoriesLoading) {
      return;
    }
    if (!event.forceRefresh && state.categories.isNotEmpty) {
      return;
    }

    emit(
      state.copyWith(areCategoriesLoading: true, clearCategoriesError: true),
    );

    try {
      final categories = await _categoriesService.getCategories(
        forceRefresh: event.forceRefresh,
      );
      emit(
        state.copyWith(
          categories: List<CategoryEntity>.unmodifiable(categories),
          areCategoriesLoading: false,
          clearCategoriesError: true,
        ),
      );
    } catch (error) {
      final message = error is Failure
          ? (error.message ?? error.code)
          : 'Failed to load categories';
      emit(
        state.copyWith(areCategoriesLoading: false, categoriesError: message),
      );
    }
  }

  void _refreshState(Emitter<BudgetState> emit) {
    final progress = _computeProgress(_budgets, _transactions);
    emit(
      state.copyWith(
        budgets: List<BudgetEntity>.unmodifiable(_budgets),
        progress: progress,
        transactions: List<TransactionEntity>.unmodifiable(_transactions),
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
      final double percentage = budget.limitAmount <= 0
          ? 0
          : spent / budget.limitAmount;

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
    final inCategory =
        category == budgetCategory ||
        (budgetCategoryId.isNotEmpty && category == budgetCategoryId);
    final inRange =
        !transaction.date.isBefore(budget.startDate) &&
        !transaction.date.isAfter(budget.endDate);
    return inCategory && inRange;
  }

  BudgetState _errorState(String message) {
    return state.copyWith(isLoading: false, errorMessage: message);
  }

  bool _shouldAllowManage(Emitter<BudgetState> emit) {
    if (_canManageCurrentWorkspace()) {
      return true;
    }

    emit(
      state.copyWith(isLoading: false, errorMessage: _permissionErrorMessage),
    );
    emitEffect(const BudgetShowErrorEffect(_permissionErrorMessage));
    return false;
  }

  bool _canManageCurrentWorkspace() {
    final snapshot = _currentWorkspace.now();
    if (snapshot == null || snapshot.isPersonal) {
      return true;
    }
    final role = (snapshot.role ?? '').toLowerCase().trim();
    return role == 'owner' || role == 'editor';
  }

  @override
  Future<void> close() async {
    await _budgetsSubscription?.cancel();
    await _transactionsSubscription?.cancel();
    _pendingDeletionTimer?.cancel();
    return super.close();
  }
}

class _PendingDeletion {
  _PendingDeletion({required this.entity, required this.index});

  final BudgetEntity entity;
  final int index;
}
