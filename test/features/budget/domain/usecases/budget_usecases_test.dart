import 'dart:async';

import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_manager/features/budget/domain/repositories/budget_repository.dart';
import 'package:expense_manager/features/budget/domain/usecases/add_budget_usecase.dart';
import 'package:expense_manager/features/budget/domain/usecases/delete_budget_usecase.dart';
import 'package:expense_manager/features/budget/domain/usecases/update_budget_usecase.dart';
import 'package:expense_manager/features/budget/domain/usecases/watch_budgets_usecase.dart';
import 'package:flutter_core/flutter_core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';

class _FakeBudgetRepository implements BudgetRepository {
  _FakeBudgetRepository();

  final _controller = StreamController<List<BudgetEntity>>.broadcast();

  BudgetEntity? added;
  BudgetEntity? updated;
  String? deletedId;
  Object? error;

  @override
  Stream<List<BudgetEntity>> watchAll() => _controller.stream;

  void emit(List<BudgetEntity> items) => _controller.add(items);

  Future<void> close() => _controller.close();

  @override
  Future<void> add(BudgetEntity entity) async {
    if (error != null) throw error!;
    added = entity;
  }

  @override
  Future<void> update(BudgetEntity entity) async {
    if (error != null) throw error!;
    updated = entity;
  }

  @override
  Future<void> deleteById(String id) async {
    if (error != null) throw error!;
    deletedId = id;
  }
}

BudgetEntity _budget(String id) => BudgetEntity(
      id: id,
      category: 'Food',
      categoryId: 'food',
      limitAmount: 100,
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 1, 31),
    );

void main() {
  group('Budget usecases', () {
    late _FakeBudgetRepository repository;

    setUp(() {
      repository = _FakeBudgetRepository();
    });

    tearDown(() async {
      await repository.close();
    });

    test('AddBudgetUseCase returns success when repository succeeds', () async {
      final usecase = AddBudgetUseCase(repository);

      final result = await usecase(AddBudgetParams(_budget('new')));

      expect(result.isSuccess, isTrue);
      expect(repository.added?.id, 'new');
    });

    test('AddBudgetUseCase maps errors via budget failure mapper', () async {
      repository.error = AuthException('auth.required');
      final usecase = AddBudgetUseCase(repository);

      final result = await usecase(AddBudgetParams(_budget('new')));

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<AuthFailure>());
    });

    test('UpdateBudgetUseCase delegates to repository', () async {
      final usecase = UpdateBudgetUseCase(repository);

      final result = await usecase(UpdateBudgetParams(_budget('update')));

      expect(result.isSuccess, isTrue);
      expect(repository.updated?.id, 'update');
    });

    test('DeleteBudgetUseCase delegates to repository', () async {
      final usecase = DeleteBudgetUseCase(repository);

      final result = await usecase(DeleteBudgetParams('delete-me'));

      expect(result.isSuccess, isTrue);
      expect(repository.deletedId, 'delete-me');
    });

    test('WatchBudgetsUseCase exposes repository stream', () async {
      final usecase = WatchBudgetsUseCase(repository);

      final future = usecase(NoParam()).first;
      repository.emit([_budget('stream')]);

      final items = await future;
      expect(items.map((b) => b.id), ['stream']);
    });
  });
}
