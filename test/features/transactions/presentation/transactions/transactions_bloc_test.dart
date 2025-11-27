import 'dart:async';

import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:expense_manager/features/transactions/domain/usecases/add_transaction_usecase.dart';
import 'package:expense_manager/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:expense_manager/features/transactions/domain/usecases/update_transaction_usecase.dart';
import 'package:expense_manager/features/transactions/domain/usecases/share_transaction_usecase.dart';
import 'package:expense_manager/features/transactions/domain/usecases/watch_transactions_usecase.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_bloc.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_effect.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_event.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_state.dart';
import 'package:flutter_core/flutter_core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';

class _FakeTransactionsRepository implements TransactionsRepository {
  final StreamController<List<TransactionEntity>> _controller =
      StreamController<List<TransactionEntity>>.broadcast(sync: true);

  Future<void> Function(TransactionEntity entity)? addImpl;
  Future<void> Function(TransactionEntity entity)? updateImpl;
  Future<void> Function(String id)? deleteImpl;
  Future<void> Function(TransactionEntity entity, String workspaceId)?
  shareImpl;
  Object? watchError;

  bool get isClosed => _controller.isClosed;

  @override
  Stream<List<TransactionEntity>> watchAll() {
    if (watchError != null) throw watchError!;
    return _controller.stream;
  }

  @override
  Future<List<TransactionEntity>> getAllOnce() async => const [];

  @override
  Future<void> add(TransactionEntity entity) async {
    if (addImpl != null) {
      await addImpl!(entity);
    }
  }

  @override
  Future<void> update(TransactionEntity entity) async {
    if (updateImpl != null) {
      await updateImpl!(entity);
    }
  }

  @override
  Future<void> deleteById(String id) async {
    if (deleteImpl != null) {
      await deleteImpl!(id);
    }
  }

  @override
  Future<void> shareToWorkspace({
    required TransactionEntity entity,
    required String workspaceId,
  }) async {
    if (shareImpl != null) {
      await shareImpl!(entity, workspaceId);
    }
  }

  void emit(List<TransactionEntity> items) {
    _controller.add(items);
  }

  void emitError(Object error) {
    _controller.addError(error);
  }

  Future<void> close() async {
    await _controller.close();
  }
}

TransactionEntity _transaction(String id, double amount) => TransactionEntity(
  id: id,
  title: 'Transaction $id',
  amount: amount,
  date: DateTime(2024, 1, 1),
  type: TransactionType.expense,
  category: 'Food',
);

Future<void> _pumpEventQueue() async {
  await Future<void>.delayed(Duration.zero);
}

void main() {
  late _FakeTransactionsRepository repository;
  late TransactionsBloc bloc;

  setUp(() {
    repository = _FakeTransactionsRepository();
    bloc = TransactionsBloc(
      WatchTransactionsUseCase(repository),
      AddTransactionUseCase(repository),
      UpdateTransactionUseCase(repository),
      DeleteTransactionUseCase(repository),
      ShareTransactionUseCase(repository),
    );
  });

  tearDown(() async {
    await bloc.close();
    if (!repository.isClosed) {
      await repository.close();
    }
  });

  group('TransactionsBloc stream', () {
    test('loads transactions from stream on start', () async {
      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<TransactionsState>().having(
            (s) => s.isLoading,
            'isLoading',
            true,
          ),
          isA<TransactionsState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.items, 'items', [
                _transaction('1', 10),
                _transaction('2', 20),
              ]),
        ]),
      );

      bloc.add(const TransactionsStarted());
      await _pumpEventQueue();

      repository.emit([_transaction('1', 10), _transaction('2', 20)]);

      await expectation;
    });

    test('surfaces stream failure as error state', () async {
      final expectation = expectLater(
        bloc.stream,
        emits(
          isA<TransactionsState>().having(
            (s) => s.errorMessage,
            'error',
            'failed',
          ),
        ),
      );

      bloc.add(const TransactionsStreamFailed('failed'));

      await expectation;
    });

    test('emits error when stream subscription throws', () async {
      repository.watchError = AuthException('watch-failed');

      final stateExpectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<TransactionsState>().having(
            (s) => s.isLoading,
            'isLoading',
            true,
          ),
          isA<TransactionsState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'error', 'watch-failed'),
        ]),
      );

      final effectExpectation = expectLater(
        bloc.effects,
        emits(
          isA<TransactionsShowErrorEffect>().having(
            (e) => e.message,
            'message',
            'watch-failed',
          ),
        ),
      );

      bloc.add(const TransactionsStarted());

      await Future.wait([stateExpectation, effectExpectation]);
    });
  });

  group('TransactionsBloc commands', () {
    test('add event toggles loading and delegates to repository', () async {
      var calledWith = <TransactionEntity>[];
      repository.addImpl = (entity) async {
        calledWith.add(entity);
      };

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<TransactionsState>().having(
            (s) => s.isLoading,
            'isLoading',
            true,
          ),
          isA<TransactionsState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'error', isNull),
        ]),
      );

      final entity = _transaction('new', 30);
      bloc.add(TransactionsAdded(entity));

      await expectation;
      expect(calledWith, [entity]);
    });

    test('add event emits error when repository throws', () async {
      repository.addImpl = (_) async {
        throw AuthException('cannot add');
      };

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<TransactionsState>().having(
            (s) => s.isLoading,
            'isLoading',
            true,
          ),
          isA<TransactionsState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'error', 'cannot add'),
        ]),
      );

      bloc.add(TransactionsAdded(_transaction('err', 5)));

      await expectation;
    });

    test('delete event delegates to repository', () async {
      var deletedId = '';
      repository.deleteImpl = (id) async {
        deletedId = id;
      };

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<TransactionsState>().having(
            (s) => s.isLoading,
            'isLoading',
            true,
          ),
          isA<TransactionsState>().having(
            (s) => s.isLoading,
            'isLoading',
            false,
          ),
        ]),
      );

      bloc.add(const TransactionsDeleted('delete-id'));

      await expectation;
      expect(deletedId, 'delete-id');
    });

    test('delete requested removes item and emits undo effect', () async {
      final first = _transaction('1', 10);
      final second = _transaction('2', 20);
      bloc.add(TransactionsStreamChanged([first, second]));
      await _pumpEventQueue();

      final effectExpectation = expectLater(
        bloc.effects,
        emits(
          isA<TransactionsShowUndoDeleteEffect>()
              .having((e) => e.message, 'message', 'Transaction deleted')
              .having((e) => e.actionLabel, 'action', 'Undo'),
        ),
      );

      bloc.add(TransactionsDeleteRequested(first));
      await _pumpEventQueue();

      expect(bloc.state.items.map((e) => e.id).toList(), ['2']);

      await effectExpectation;
    });

    test('delete requested commits after timeout when not undone', () async {
      var deletedId = '';
      repository.deleteImpl = (id) async {
        deletedId = id;
      };

      final tx = _transaction('delete-id', 15);
      bloc.add(TransactionsStreamChanged([tx]));
      await _pumpEventQueue();

      bloc.add(TransactionsDeleteRequested(tx));
      await _pumpEventQueue();

      await Future<void>.delayed(const Duration(milliseconds: 3100));
      await _pumpEventQueue();

      expect(deletedId, 'delete-id');
    });

    test('delete undo restores item and prevents deletion', () async {
      var deleted = false;
      repository.deleteImpl = (_) async {
        deleted = true;
      };

      final first = _transaction('1', 10);
      final second = _transaction('2', 20);
      bloc.add(TransactionsStreamChanged([first, second]));
      await _pumpEventQueue();

      bloc.add(TransactionsDeleteRequested(first));
      await _pumpEventQueue();
      bloc.add(const TransactionsDeleteUndoRequested());
      await _pumpEventQueue();

      await Future<void>.delayed(const Duration(milliseconds: 20));
      await _pumpEventQueue();

      expect(deleted, isFalse);
      expect(bloc.state.items.map((e) => e.id).toList(), ['1', '2']);
    });

    test('update event emits error when repository throws', () async {
      repository.updateImpl = (_) async {
        throw AuthException('cannot update');
      };

      final stateExpectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<TransactionsState>().having(
            (s) => s.isLoading,
            'isLoading',
            true,
          ),
          isA<TransactionsState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'error', 'cannot update'),
        ]),
      );

      final effectExpectation = expectLater(
        bloc.effects,
        emits(
          isA<TransactionsShowErrorEffect>().having(
            (e) => e.message,
            'message',
            'cannot update',
          ),
        ),
      );

      bloc.add(TransactionsUpdated(_transaction('update', 10)));

      await Future.wait([stateExpectation, effectExpectation]);
    });

    test('share requested delegates to repository and shows success', () async {
      String? capturedWorkspaceId;
      repository.shareImpl = (entity, workspaceId) async {
        capturedWorkspaceId = workspaceId;
      };

      final stateExpectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<TransactionsState>().having(
            (s) => s.isLoading,
            'isLoading',
            true,
          ),
          isA<TransactionsState>().having(
            (s) => s.isLoading,
            'isLoading',
            false,
          ),
        ]),
      );

      final effectExpectation = expectLater(
        bloc.effects,
        emits(
          isA<TransactionsShowSuccessEffect>().having(
            (e) => e.message,
            'message',
            contains('Household'),
          ),
        ),
      );

      final entity = _transaction('source', 10);
      bloc.add(
        TransactionsShareRequested(
          entity: entity,
          targetWorkspaceId: 'household-123',
          targetWorkspaceName: 'Household',
        ),
      );

      await Future.wait([stateExpectation, effectExpectation]);
      expect(capturedWorkspaceId, 'household-123');
    });

    test('share requested emits error effect when repository throws', () async {
      repository.shareImpl = (_, __) async {
        throw AuthException('share-failed');
      };

      final stateExpectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<TransactionsState>().having(
            (s) => s.isLoading,
            'isLoading',
            true,
          ),
          isA<TransactionsState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'error', 'share-failed'),
        ]),
      );

      final effectExpectation = expectLater(
        bloc.effects,
        emits(
          isA<TransactionsShowErrorEffect>().having(
            (e) => e.message,
            'message',
            'share-failed',
          ),
        ),
      );

      bloc.add(
        TransactionsShareRequested(
          entity: _transaction('source', 10),
          targetWorkspaceId: 'household-123',
          targetWorkspaceName: 'Household',
        ),
      );

      await Future.wait([stateExpectation, effectExpectation]);
    });

    test('delete event emits error when repository throws', () async {
      repository.deleteImpl = (_) async {
        throw AuthException('cannot delete');
      };

      final stateExpectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<TransactionsState>().having(
            (s) => s.isLoading,
            'isLoading',
            true,
          ),
          isA<TransactionsState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'error', 'cannot delete'),
        ]),
      );

      final effectExpectation = expectLater(
        bloc.effects,
        emits(
          isA<TransactionsShowErrorEffect>().having(
            (e) => e.message,
            'message',
            'cannot delete',
          ),
        ),
      );

      bloc.add(const TransactionsDeleted('delete-id'));

      await Future.wait([stateExpectation, effectExpectation]);
    });
  });
}
