import 'dart:async';

import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_manager/features/budget/domain/repositories/budget_repository.dart';
import 'package:expense_manager/features/budget/domain/usecases/add_budget_usecase.dart';
import 'package:expense_manager/features/budget/domain/usecases/delete_budget_usecase.dart';
import 'package:expense_manager/features/budget/domain/usecases/update_budget_usecase.dart';
import 'package:expense_manager/features/budget/domain/usecases/watch_budgets_usecase.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_bloc.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_effect.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_event.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_state.dart';
import 'package:expense_manager/features/categories/application/categories_service.dart' show CategoriesService;
import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/categories/domain/repositories/category_repository.dart';
import 'package:expense_manager/features/categories/domain/usecases/load_categories_usecase.dart' show LoadCategoriesUseCase;
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:expense_manager/features/transactions/domain/usecases/watch_transactions_usecase.dart';
import 'package:flutter_core/flutter_core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';

class _FakeBudgetRepository implements BudgetRepository {
  _FakeBudgetRepository(this._stream);

  final Stream<List<BudgetEntity>> _stream;
  Object? watchError;
  Object? addError;
  Object? updateError;
  Object? deleteError;
  BudgetEntity? added;
  BudgetEntity? updatedEntity;
  String? deletedId;

  @override
  Stream<List<BudgetEntity>> watchAll() {
    if (watchError != null) throw watchError!;
    return _stream;
  }

  @override
  Future<void> add(BudgetEntity entity) async {
    if (addError != null) throw addError!;
    added = entity;
  }

  @override
  Future<void> update(BudgetEntity entity) async {
    if (updateError != null) throw updateError!;
    updatedEntity = entity;
  }

  @override
  Future<void> deleteById(String id) async {
    if (deleteError != null) throw deleteError!;
    deletedId = id;
  }

  @override
  void dispose() {}
}

class _FakeTransactionsRepository implements TransactionsRepository {
  _FakeTransactionsRepository(this._stream);

  final Stream<List<TransactionEntity>> _stream;
  Object? watchError;

  @override
  Stream<List<TransactionEntity>> watchAll() {
    if (watchError != null) throw watchError!;
    return _stream;
  }

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

class _FakeCategoryRepository implements CategoryRepository {

  @override
  Future<List<CategoryEntity>> fetchAll() async => const [];

  @override
  Stream<List<CategoryEntity>> watchAll() {
    // TODO: implement watchAll
    throw UnimplementedError();
  }

}

Future<void> _pumpEventQueue() async {
  await Future<void>.delayed(Duration.zero);
}

void main() {
  group('BudgetBloc progress', () {
    late StreamController<List<BudgetEntity>> budgetsController;
    late StreamController<List<TransactionEntity>> transactionsController;
    late BudgetBloc bloc;
    late _FakeBudgetRepository budgetRepository;
    late _FakeTransactionsRepository transactionsRepository;
    late _FakeCategoryRepository categoryRepository;

    setUp(() {
      budgetsController =
          StreamController<List<BudgetEntity>>.broadcast(sync: true);
      transactionsController =
          StreamController<List<TransactionEntity>>.broadcast(sync: true);

      budgetRepository = _FakeBudgetRepository(budgetsController.stream);
      transactionsRepository =
          _FakeTransactionsRepository(transactionsController.stream);
      categoryRepository = _FakeCategoryRepository();

      bloc = BudgetBloc(
        WatchBudgetsUseCase(budgetRepository),
        AddBudgetUseCase(budgetRepository),
        UpdateBudgetUseCase(budgetRepository),
        DeleteBudgetUseCase(budgetRepository),
        WatchTransactionsUseCase(transactionsRepository),
          CategoriesService(LoadCategoriesUseCase(categoryRepository))
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
        type: TransactionType.expense,
        category: 'Food',
      );

      final outOfRange = TransactionEntity(
        id: 'tx-2',
        title: 'Late dinner',
        amount: 300_000,
        date: DateTime(2024, 2, 1),
        type: TransactionType.expense,
        category: 'Food',
      );

      final differentCategory = TransactionEntity(
        id: 'tx-3',
        title: 'Books',
        amount: 500_000,
        date: DateTime(2024, 1, 15),
        type: TransactionType.expense,
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
          type: TransactionType.expense,
          category: 'Travel',
        ),
        TransactionEntity(
          id: 'tx-overspend-2',
          title: 'Hotel',
          amount: 900_000,
          date: DateTime(2024, 6, 12),
          type: TransactionType.expense,
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

    test('emits error state when budget stream fails to start', () async {
      budgetRepository.watchError = AuthException('budget.failed');

      final stateExpectation = expectLater(
        bloc.stream,
        emitsThrough(
          predicate<BudgetState>(
            (state) => state.errorMessage == 'budget.failed',
          ),
        ),
      );

      final effectExpectation = expectLater(
        bloc.effects,
        emits(
          isA<BudgetShowErrorEffect>()
              .having((effect) => effect.message, 'message', 'budget.failed'),
        ),
      );

      bloc.add(const BudgetStarted());

      await Future.wait([stateExpectation, effectExpectation]);
    });

    test('emits error state when transactions stream fails to start', () async {
      transactionsRepository.watchError = AuthException('tx.failed');

      final stateExpectation = expectLater(
        bloc.stream,
        emitsThrough(
          predicate<BudgetState>(
            (state) => state.errorMessage == 'tx.failed',
          ),
        ),
      );

      final effectExpectation = expectLater(
        bloc.effects,
        emits(
          isA<BudgetShowErrorEffect>()
              .having((effect) => effect.message, 'message', 'tx.failed'),
        ),
      );

      bloc.add(const BudgetStarted());

      await Future.wait([stateExpectation, effectExpectation]);
    });

    test('emits dialog effect when BudgetShowDialogAdd is triggered', () async {
      final budget = BudgetEntity(
        id: 'b',
        category: 'Food',
        limitAmount: 100,
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 31),
      );

      final effectExpectation = expectLater(
        bloc.effects,
        emits(
          isA<BudgetShowDialogAddEffect>()
              .having((effect) => effect.budget, 'budget', budget),
        ),
      );

      bloc.add(BudgetShowDialogAdd(budget: budget));

      await effectExpectation;
    });

    test('emits error effect when add budget fails', () async {
      budgetRepository.addError = AuthException('add.failed');
      final budget = BudgetEntity(
        id: 'b',
        category: 'Food',
        limitAmount: 100,
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 31),
      );

      final stateExpectation = expectLater(
        bloc.stream,
        emitsThrough(
          predicate<BudgetState>(
            (state) =>
                state.errorMessage == 'add.failed' && !state.isLoading,
          ),
        ),
      );

      final effectExpectation = expectLater(
        bloc.effects,
        emits(
          isA<BudgetShowErrorEffect>()
              .having((effect) => effect.message, 'message', 'add.failed'),
        ),
      );

      bloc.add(BudgetAdded(budget));

      await Future.wait([stateExpectation, effectExpectation]);
    });

    test('BudgetStreamFailed emits error state and effect', () async {
      final stateExpectation = expectLater(
        bloc.stream,
        emitsThrough(
          predicate<BudgetState>(
            (state) =>
                state.errorMessage == 'stream-error' && !state.isLoading,
          ),
        ),
      );

      final effectExpectation = expectLater(
        bloc.effects,
        emits(
          isA<BudgetShowErrorEffect>()
              .having((effect) => effect.message, 'message', 'stream-error'),
        ),
      );

      bloc.add(const BudgetStreamFailed('stream-error'));

      await Future.wait([stateExpectation, effectExpectation]);
    });

    test('successfully adds budget through usecase', () async {
      final budget = BudgetEntity(
        id: 'b',
        category: 'Food',
        limitAmount: 100,
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 31),
      );

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<BudgetState>().having((s) => s.isLoading, 'isLoading', true),
          isA<BudgetState>().having((s) => s.isLoading, 'isLoading', false),
        ]),
      );

      bloc.add(BudgetAdded(budget));

      await expectation;
      expect(budgetRepository.added, budget);
    });

    test('successfully updates budget', () async {
      final budget = BudgetEntity(
        id: 'b',
        category: 'Food',
        limitAmount: 150,
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 31),
      );

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<BudgetState>().having((s) => s.isLoading, 'isLoading', true),
          isA<BudgetState>().having((s) => s.isLoading, 'isLoading', false),
        ]),
      );

      bloc.add(BudgetUpdated(budget));

      await expectation;
      expect(budgetRepository.updatedEntity, budget);
    });

    test('successfully deletes budget', () async {
      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<BudgetState>().having((s) => s.isLoading, 'isLoading', true),
          isA<BudgetState>().having((s) => s.isLoading, 'isLoading', false),
        ]),
      );

      bloc.add(const BudgetDeleted('delete-me'));

      await expectation;
      expect(budgetRepository.deletedId, 'delete-me');
    });
  });
}
