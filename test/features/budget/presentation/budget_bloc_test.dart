import 'dart:async';

import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_manager/features/budget/domain/repositories/budget_repository.dart';
import 'package:expense_manager/features/budget/domain/usecases/add_budget_usecase.dart';
import 'package:expense_manager/features/budget/domain/usecases/delete_budget_usecase.dart';
import 'package:expense_manager/features/budget/domain/usecases/update_budget_usecase.dart';
import 'package:expense_manager/features/budget/domain/usecases/watch_budgets_usecase.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_bloc.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_event.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:expense_manager/features/transactions/domain/usecases/watch_transactions_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeBudgetRepository implements BudgetRepository {
  _FakeBudgetRepository(this._stream);

  final Stream<List<BudgetEntity>> _stream;

  @override
  Stream<List<BudgetEntity>> watchAll() => _stream;

  @override
  Future<void> add(BudgetEntity entity) async {}

  @override
  Future<void> update(BudgetEntity entity) async {}

  @override
  Future<void> deleteById(String id) async {}

  @override
  void dispose() {}
}

class _FakeTransactionsRepository implements TransactionsRepository {
  _FakeTransactionsRepository(this._stream);

  final Stream<List<TransactionEntity>> _stream;

  @override
  Stream<List<TransactionEntity>> watchAll() => _stream;

  @override
  Future<List<TransactionEntity>> getAllOnce() async => const [];

  @override
  Future<void> add(TransactionEntity entity) async {}

  @override
  Future<void> update(TransactionEntity entity) async {}

  @override
  Future<void> deleteById(String id) async {}

  @override
  void dispose() {}
}

Future<void> _pumpEventQueue() async {
  await Future<void>.delayed(Duration.zero);
}

void main() {
  group('BudgetBloc progress', () {
    late StreamController<List<BudgetEntity>> budgetsController;
    late StreamController<List<TransactionEntity>> transactionsController;
    late BudgetBloc bloc;

    setUp(() {
      budgetsController =
          StreamController<List<BudgetEntity>>.broadcast(sync: true);
      transactionsController =
          StreamController<List<TransactionEntity>>.broadcast(sync: true);

      final budgetRepository = _FakeBudgetRepository(budgetsController.stream);
      final transactionsRepository =
          _FakeTransactionsRepository(transactionsController.stream);

      bloc = BudgetBloc(
        WatchBudgetsUseCase(budgetRepository),
        AddBudgetUseCase(budgetRepository),
        UpdateBudgetUseCase(budgetRepository),
        DeleteBudgetUseCase(budgetRepository),
        WatchTransactionsUseCase(transactionsRepository),
      );
    });

    tearDown(() async {
      await bloc.close();
      await budgetsController.close();
      await transactionsController.close();
    });

    test('deducts matching expenses from remaining amount', () async {
      final budget = BudgetEntity(
        id: 'budget-1',
        category: 'Food',
        limitAmount: 5_000_000,
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 31),
        categoryId: 'food',
      );

      final matching = TransactionEntity(
        id: 'tx-1',
        title: 'Dinner',
        amount: 2_000_000,
        date: DateTime(2024, 1, 10),
        category: 'Food',
      );

      final outOfRange = TransactionEntity(
        id: 'tx-2',
        title: 'Late dinner',
        amount: 300_000,
        date: DateTime(2024, 2, 1),
        category: 'Food',
      );

      final differentCategory = TransactionEntity(
        id: 'tx-3',
        title: 'Books',
        amount: 500_000,
        date: DateTime(2024, 1, 15),
        category: 'Education',
      );

      bloc.add(const BudgetStarted());
      await _pumpEventQueue();

      budgetsController.add([budget]);
      await _pumpEventQueue();

      transactionsController.add([
        matching,
        outOfRange,
        differentCategory,
      ]);
      await _pumpEventQueue();
      await _pumpEventQueue();

      final progress = bloc.state.progress[budget.id];
      expect(progress, isNotNull);
      expect(progress!.spentAmount, 2_000_000);
      expect(progress.remainingAmount, 3_000_000);
      expect(progress.percentage, closeTo(0.4, 1e-9));
    });

    test('allows remaining amount to drop below zero when overspending occurs',
        () async {
      final budget = BudgetEntity(
        id: 'budget-overspend',
        category: 'Travel',
        limitAmount: 1_500_000,
        startDate: DateTime(2024, 6, 1),
        endDate: DateTime(2024, 6, 30),
        categoryId: 'travel',
      );

      bloc.add(const BudgetStarted());
      await _pumpEventQueue();

      budgetsController.add([budget]);
      await _pumpEventQueue();

      transactionsController.add([
        TransactionEntity(
          id: 'tx-overspend-1',
          title: 'Flight',
          amount: 1_000_000,
          date: DateTime(2024, 6, 5),
          category: 'Travel',
        ),
        TransactionEntity(
          id: 'tx-overspend-2',
          title: 'Hotel',
          amount: 900_000,
          date: DateTime(2024, 6, 12),
          category: 'Travel',
        ),
      ]);
      await _pumpEventQueue();
      await _pumpEventQueue();

      final progress = bloc.state.progress[budget.id];
      expect(progress, isNotNull);
      expect(progress!.spentAmount, 1_900_000);
      expect(progress.remainingAmount, -400_000);
      expect(progress.percentage, closeTo(1_900_000 / 1_500_000, 1e-9));
    });
  });
}
