import 'dart:async';

import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/features/home/presentation/summary/bloc/summary_effect.dart';
import 'package:expense_manager/features/home/presentation/summary/bloc/summary_event.dart';
import 'package:expense_manager/features/home/presentation/summary/bloc/summary_state.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/transactions/domain/usecases/watch_transactions_usecase.dart';
import 'package:expense_manager/features/transactions/domain/usecases/transactions_failure_mapper.dart';
import 'package:flutter_core/flutter_core.dart';

@injectable
class SummaryBloc extends BaseBloc<SummaryEvent, SummaryState, SummaryEffect> {
  SummaryBloc(
    this._currentUser,
    this._watchTransactionsUseCase, {
    Logger? logger,
  }) : super(const SummaryState(isLoading: true), logger: logger) {
    on<SummaryStarted>(_onStarted);
    on<SummaryUserChanged>(_onUserChanged);
    on<SummaryTransactionsUpdated>(_onTransactionsUpdated);
    on<SummaryStreamFailed>(_onStreamFailed);
  }

  final CurrentUser _currentUser;
  final WatchTransactionsUseCase _watchTransactionsUseCase;

  StreamSubscription<CurrentUserSnapshot?>? _userSubscription;
  StreamSubscription<List<TransactionEntity>>? _transactionsSubscription;

  CurrentUserSnapshot? _snapshot;
  List<TransactionEntity> _transactions = const <TransactionEntity>[];

  Future<void> _onStarted(
    SummaryStarted event,
    Emitter<SummaryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    _userSubscription ??= _currentUser.watch().listen(
      (snapshot) => add(SummaryUserChanged(snapshot)),
      onError: (Object error, StackTrace stackTrace) {
        add(SummaryStreamFailed(error.toString()));
      },
    );

    try {
      _transactionsSubscription ??= _watchTransactionsUseCase(NoParam()).listen(
        (transactions) => add(SummaryTransactionsUpdated(transactions)),
        onError: (Object error, StackTrace stackTrace) {
          final failure = mapTransactionsError(error, stackTrace);
          add(SummaryStreamFailed(failure.message ?? failure.code));
        },
      );
    } catch (error, stackTrace) {
      final failure = mapTransactionsError(error, stackTrace);
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: failure.message ?? failure.code,
        ),
      );
      emitEffect(SummaryShowErrorEffect(failure.message ?? failure.code));
    }
  }

  void _onUserChanged(SummaryUserChanged event, Emitter<SummaryState> emit) {
    _snapshot = event.snapshot;
    _refreshState(emit);
  }

  void _onTransactionsUpdated(
    SummaryTransactionsUpdated event,
    Emitter<SummaryState> emit,
  ) {
    _transactions = event.transactions;
    _refreshState(emit);
  }

  void _onStreamFailed(SummaryStreamFailed event, Emitter<SummaryState> emit) {
    emit(state.copyWith(isLoading: false, errorMessage: event.message));
    emitEffect(SummaryShowErrorEffect(event.message));
  }

  void _refreshState(Emitter<SummaryState> emit) {
    final greeting = _buildGreeting(_snapshot);
    final now = DateTime.now();
    DateTime dateOnly(DateTime date) =>
        DateTime(date.year, date.month, date.day);
    final today = dateOnly(now);
    final startDate = today.subtract(const Duration(days: 6));

    final dailyExpenses = <DateTime, double>{
      for (var offset = 0; offset < 7; offset++)
        startDate.add(Duration(days: offset)): 0,
    };
    final monthlyTransactions = _transactions.where(
      (transaction) =>
          transaction.date.year == now.year &&
          transaction.date.month == now.month,
    );
    double monthlyIncome = 0;
    double monthlyExpense = 0;
    for (final transaction in monthlyTransactions) {
      if (transaction.type == TransactionType.income) {
        monthlyIncome += transaction.amount;
      } else {
        monthlyExpense += transaction.amount;
      }
    }

    for (final transaction in _transactions) {
      if (!transaction.type.isExpense) {
        continue;
      }
      final transactionDate = dateOnly(transaction.date.toLocal());
      if (transactionDate.isBefore(startDate) ||
          transactionDate.isAfter(today)) {
        continue;
      }
      dailyExpenses[transactionDate] =
          (dailyExpenses[transactionDate] ?? 0) + transaction.amount;
    }
    final weeklyExpenses =
        dailyExpenses.entries
            .map(
              (entry) =>
                  SummaryDailySpending(date: entry.key, amount: entry.value),
            )
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));

    final monthlyRemaining = monthlyIncome - monthlyExpense;
    final sorted = List<TransactionEntity>.from(_transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    final recent = sorted.take(5).toList(growable: false);

    emit(
      state.copyWith(
        greeting: greeting,
        monthlyIncome: monthlyIncome,
        monthlyExpense: monthlyExpense,
        monthlyRemaining: monthlyRemaining,
        weeklyExpenses: weeklyExpenses,
        recentTransactions: recent,
        isLoading: false,
        clearError: true,
      ),
    );
  }

  String _buildGreeting(CurrentUserSnapshot? snapshot) {
    final name = snapshot?.displayName?.trim();
    if (name != null && name.isNotEmpty) {
      return name;
    }
    final email = snapshot?.email?.trim();
    if (email != null && email.isNotEmpty) {
      return email.split('@').first;
    }
    return 'Guest';
  }

  @override
  Future<void> close() async {
    await _userSubscription?.cancel();
    await _transactionsSubscription?.cancel();
    return super.close();
  }
}
