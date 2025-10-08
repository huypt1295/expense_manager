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
    this._deleteTransactionUseCase, {
    Duration undoDuration = const Duration(seconds: 5),
  }) : _undoDuration = undoDuration,
        super(const TransactionsState()) {
    on<TransactionsStarted>(_onStarted);
    on<TransactionsStreamChanged>(_onStreamChanged);
    on<TransactionsStreamFailed>(_onStreamFailed);
    on<TransactionsAdded>(_onAdded);
    on<TransactionsUpdated>(_onUpdated);
    on<TransactionsDeleteRequested>(_onDeleteRequested);
    on<TransactionsDeleteUndoRequested>(_onDeleteUndoRequested);
    on<TransactionsDeleted>(_onDeleted);
  }

  final WatchTransactionsUseCase _watchTransactionsUseCase;
  final AddTransactionUseCase _addTransactionUseCase;
  final UpdateTransactionUseCase _updateTransactionUseCase;
  final DeleteTransactionUseCase _deleteTransactionUseCase;

  final Duration _undoDuration;

  StreamSubscription<List<TransactionEntity>>? _subscription;
  _PendingDeletion? _pendingDeletion;
  _PendingDeletion? _committingDeletion;
  Timer? _pendingDeletionTimer;

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
        ? event.items
        : event.items
            .where((item) => !idsToOmit.contains(item.id))
            .toList();

    emit(
      state.copyWith(
        items: items,
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

  void _onDeleteRequested(
    TransactionsDeleteRequested event,
    Emitter<TransactionsState> emit,
  ) {
    _commitPendingDeletion();

    final currentItems = state.items;
    final index =
        currentItems.indexWhere((item) => item.id == event.entity.id);
    if (index == -1) {
      return;
    }

    final updatedItems = List<TransactionEntity>.of(currentItems)
      ..removeAt(index);
    emit(
      state.copyWith(
        items: updatedItems,
        clearError: true,
      ),
    );

    _pendingDeletion = _PendingDeletion(entity: event.entity, index: index);
    _startPendingDeletionTimer();

    emitEffect(
      TransactionsShowUndoDeleteEffect(
        message: 'Transaction deleted',
        actionLabel: 'Undo',
        duration: _undoDuration,
      ),
    );
  }

  void _onDeleteUndoRequested(
    TransactionsDeleteUndoRequested event,
    Emitter<TransactionsState> emit,
  ) {
    final pending = _pendingDeletion;
    if (pending == null) {
      return;
    }

    _pendingDeletionTimer?.cancel();
    _pendingDeletionTimer = null;
    _pendingDeletion = null;

    final updatedItems = List<TransactionEntity>.of(state.items)
      ..removeWhere((item) => item.id == pending.entity.id);
    final insertIndex = pending.index.clamp(0, updatedItems.length);
    updatedItems.insert(insertIndex, pending.entity);

    emit(
      state.copyWith(
        items: updatedItems,
        clearError: true,
      ),
    );
  }

  void _startPendingDeletionTimer() {
    _pendingDeletionTimer?.cancel();
    _pendingDeletionTimer = Timer(_undoDuration, _commitPendingDeletion);
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
    add(TransactionsDeleted(pending.entity.id));
  }

  void _handleDeletionFailure(
    Emitter<TransactionsState> emit,
    Failure failure,
  ) {
    final committing = _committingDeletion;
    final message = failure.message ?? failure.code;

    if (committing != null) {
      final items = List<TransactionEntity>.of(state.items)
        ..removeWhere((item) => item.id == committing.entity.id);
      final insertIndex = committing.index.clamp(0, items.length);
      items.insert(insertIndex, committing.entity);
      _committingDeletion = null;

      emit(
        state.copyWith(
          items: items,
          isLoading: false,
          errorMessage: message,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: message,
        ),
      );
    }

    emitEffect(TransactionsShowErrorEffect(message));
  }

  Future<void> _onDeleted(
    TransactionsDeleted event,
    Emitter<TransactionsState> emit,
  ) async {
    await runResult<void>(
      emit: emit,
      task: () => _deleteTransactionUseCase(DeleteTransactionParams(event.id)),
      onStart: (state) => state.copyWith(isLoading: true, clearError: true),
      onOk: (state, _) {
        _committingDeletion = null;
        return state.copyWith(isLoading: false);
      },
      onErr: (currentState, failure) {
        _handleDeletionFailure(emit, failure);
      },
      trackKey: 'transactions.delete',
      spanName: 'transactions.delete',
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    _pendingDeletionTimer?.cancel();
    return super.close();
  }
}

class _PendingDeletion {
  _PendingDeletion({
    required this.entity,
    required this.index,
  });

  final TransactionEntity entity;
  final int index;
}
