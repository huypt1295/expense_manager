import 'dart:async';

import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/domain/usecases/add_transaction_usecase.dart';
import 'package:expense_manager/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:expense_manager/features/transactions/domain/usecases/update_transaction_usecase.dart';
import 'package:expense_manager/features/transactions/domain/usecases/watch_transactions_usecase.dart';
import 'package:expense_manager/features/transactions/domain/usecases/transactions_failure_mapper.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_effect.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_event.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_state.dart';
import 'package:flutter_core/flutter_core.dart';

@injectable
class TransactionsBloc
    extends BaseBloc<TransactionsEvent, TransactionsState, TransactionsEffect> {
  TransactionsBloc(
    this._watchTransactionsUseCase,
    this._addTransactionUseCase,
    this._updateTransactionUseCase,
    this._deleteTransactionUseCase,
  ) : super(const TransactionsState()) {
    on<TransactionsStarted>(_onStarted);
    on<TransactionsStreamChanged>(_onStreamChanged);
    on<TransactionsStreamFailed>(_onStreamFailed);
    on<TransactionsAdded>(_onAdded);
    on<TransactionsUpdated>(_onUpdated);
    on<TransactionsDeleted>(_onDeleted);
  }

  final WatchTransactionsUseCase _watchTransactionsUseCase;
  final AddTransactionUseCase _addTransactionUseCase;
  final UpdateTransactionUseCase _updateTransactionUseCase;
  final DeleteTransactionUseCase _deleteTransactionUseCase;

  StreamSubscription<List<TransactionEntity>>? _subscription;

  Future<void> _onStarted(
    TransactionsStarted event,
    Emitter<TransactionsState> emit,
  ) async {
    if (_subscription != null) {
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final stream = _watchTransactionsUseCase(NoParam());
      _subscription = stream.listen(
        (items) => add(TransactionsStreamChanged(items)),
        onError: (Object error, StackTrace stackTrace) {
          final failure = mapTransactionsError(error, stackTrace);
          add(TransactionsStreamFailed(failure.message ?? failure.code));
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
      emitEffect(
        TransactionsShowErrorEffect(failure.message ?? failure.code),
      );
    }
  }

  void _onStreamChanged(
    TransactionsStreamChanged event,
    Emitter<TransactionsState> emit,
  ) {
    emit(
      state.copyWith(
        items: event.items,
        isLoading: false,
        clearError: true,
      ),
    );
  }

  void _onStreamFailed(
    TransactionsStreamFailed event,
    Emitter<TransactionsState> emit,
  ) {
    emit(state.copyWith(isLoading: false, errorMessage: event.message));
    emitEffect(TransactionsShowErrorEffect(event.message));
  }

  Future<void> _onAdded(
    TransactionsAdded event,
    Emitter<TransactionsState> emit,
  ) async {
    await runResult<void>(
      emit: emit,
      task: () => _addTransactionUseCase(AddTransactionParams(event.entity)),
      onStart: (state) => state.copyWith(isLoading: true, clearError: true),
      onOk: (state, _) => state.copyWith(isLoading: false),
      onErr: (currentState, failure) {
        final message = failure.message ?? failure.code;
        emitEffect(TransactionsShowErrorEffect(message));
        emit(currentState.copyWith(isLoading: false, errorMessage: message));
      },
      trackKey: 'transactions.add',
      spanName: 'transactions.add',
    );
  }

  Future<void> _onUpdated(
    TransactionsUpdated event,
    Emitter<TransactionsState> emit,
  ) async {
    await runResult<void>(
      emit: emit,
      task: () =>
          _updateTransactionUseCase(UpdateTransactionParams(event.entity)),
      onStart: (state) => state.copyWith(isLoading: true, clearError: true),
      onOk: (state, _) => state.copyWith(isLoading: false),
      onErr: (currentState, failure) {
        final message = failure.message ?? failure.code;
        emitEffect(TransactionsShowErrorEffect(message));
        emit(currentState.copyWith(isLoading: false, errorMessage: message));
      },
      trackKey: 'transactions.update',
      spanName: 'transactions.update',
    );
  }

  Future<void> _onDeleted(
    TransactionsDeleted event,
    Emitter<TransactionsState> emit,
  ) async {
    await runResult<void>(
      emit: emit,
      task: () => _deleteTransactionUseCase(DeleteTransactionParams(event.id)),
      onStart: (state) => state.copyWith(isLoading: true, clearError: true),
      onOk: (state, _) => state.copyWith(isLoading: false),
      onErr: (currentState, failure) {
        final message = failure.message ?? failure.code;
        emitEffect(TransactionsShowErrorEffect(message));
        emit(currentState.copyWith(isLoading: false, errorMessage: message));
      },
      trackKey: 'transactions.delete',
      spanName: 'transactions.delete',
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
