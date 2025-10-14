import 'dart:async';

import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/features/home/presentation/summary/bloc/summary_bloc.dart';
import 'package:expense_manager/features/home/presentation/summary/bloc/summary_event.dart';
import 'package:expense_manager/features/home/presentation/summary/bloc/summary_state.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:expense_manager/features/transactions/domain/usecases/watch_transactions_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeCurrentUser implements CurrentUser {
  _FakeCurrentUser(this.snapshot);

  CurrentUserSnapshot? snapshot;
  final StreamController<CurrentUserSnapshot?> _controller =
      StreamController<CurrentUserSnapshot?>.broadcast(sync: true);

  @override
  CurrentUserSnapshot? now() => snapshot;

  @override
  Stream<CurrentUserSnapshot?> watch() => _controller.stream;

  void emit(CurrentUserSnapshot? value) {
    snapshot = value;
    _controller.add(value);
  }

  Future<void> close() async {
    await _controller.close();
  }
}

class _FakeTransactionsRepository implements TransactionsRepository {
  final StreamController<List<TransactionEntity>> _controller =
      StreamController<List<TransactionEntity>>.broadcast(sync: true);

  @override
  Stream<List<TransactionEntity>> watchAll() => _controller.stream;

  @override
  Future<List<TransactionEntity>> getAllOnce() async => const [];

  @override
  Future<void> add(TransactionEntity entity) async {}

  @override
  Future<void> update(TransactionEntity entity) async {}

  @override
  Future<void> deleteById(String id) async {}

  void emit(List<TransactionEntity> items) {
    _controller.add(items);
  }

  Future<void> close() async {
    await _controller.close();
  }
}

TransactionEntity _transaction(String id, DateTime date, double amount) =>
    TransactionEntity(
      id: id,
      title: 'Tx $id',
      amount: amount,
      date: date,
      type: TransactionType.expense,
      category: 'Food',
    );

Future<void> _pumpEventQueue() async {
  await Future<void>.delayed(Duration.zero);
}

void main() {
  late _FakeCurrentUser currentUser;
  late _FakeTransactionsRepository repository;
  late SummaryBloc bloc;

  setUp(() {
    currentUser = _FakeCurrentUser(const CurrentUserSnapshot(uid: 'uid'));
    repository = _FakeTransactionsRepository();
    bloc = SummaryBloc(
      currentUser,
      WatchTransactionsUseCase(repository),
    );
  });

  tearDown(() async {
    await bloc.close();
    await currentUser.close();
    await repository.close();
  });

  test('builds greeting and month total from streams', () async {
    final now = DateTime.now();
    final currentMonthDate = DateTime(now.year, now.month, 10);
    final previousMonthDate = currentMonthDate.subtract(const Duration(days: 40));

    final expectation = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<SummaryState>().having((s) => s.isLoading, 'isLoading', true),
        isA<SummaryState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.greeting, 'greeting', 'Alice'),
        isA<SummaryState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.monthTotal, 'monthTotal', 150)
            .having(
              (s) => s.recentTransactions.first.id,
              'recent[0]',
              'tx-2',
            ),
      ]),
    );

    bloc.add(const SummaryStarted());
    await _pumpEventQueue();

    currentUser.emit(
      const CurrentUserSnapshot(uid: 'uid', displayName: 'Alice'),
    );

    repository.emit([
      _transaction('tx-1', currentMonthDate, 50),
      _transaction('tx-2', currentMonthDate.add(const Duration(days: 2)), 100),
      _transaction('tx-old', previousMonthDate, 999),
    ]);

    await expectation;
  });

  test('falls back to email prefix when name missing', () async {
    final expectation = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<SummaryState>().having((s) => s.isLoading, 'isLoading', true),
        isA<SummaryState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.greeting, 'greeting', 'user'),
      ]),
    );

    bloc.add(const SummaryStarted());
    await _pumpEventQueue();

    currentUser.emit(
      const CurrentUserSnapshot(
        uid: 'uid',
        email: 'user@example.com',
      ),
    );

    repository.emit(const []);

    await expectation;
  });

  test('emits error state when stream reports failure', () async {
    final expectation = expectLater(
      bloc.stream,
      emits(
        isA<SummaryState>()
            .having((s) => s.errorMessage, 'error', 'boom')
            .having((s) => s.isLoading, 'isLoading', false),
      ),
    );

    bloc.add(const SummaryStreamFailed('boom'));

    await expectation;
  });
}
