import 'dart:async';

import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/categories/domain/repositories/category_repository.dart';
import 'package:expense_manager/features/categories/domain/usecases/create_workspace_category_usecase.dart';
import 'package:expense_manager/features/categories/domain/usecases/delete_workspace_category_usecase.dart';
import 'package:expense_manager/features/categories/domain/usecases/update_workspace_category_usecase.dart';
import 'package:expense_manager/features/categories/domain/usecases/watch_workspace_categories_usecase.dart';
import 'package:flutter_core/flutter_core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';

class _FakeCategoryRepository implements CategoryRepository {
  final _controller = StreamController<List<CategoryEntity>>.broadcast();

  CategoryEntity? createdCategory;
  CategoryEntity? updatedCategory;
  String? deletedCategoryId;
  Object? error;

  @override
  Stream<List<CategoryEntity>> watchWorkspaceCategories() => _controller.stream;

  @override
  Stream<List<CategoryEntity>> watchCombined() => _controller.stream;

  @override
  Future<List<CategoryEntity>> fetchCombined() async => [];

  @override
  Future<List<CategoryEntity>> fetchWorkspaceCategories() async => [];

  void emit(List<CategoryEntity> categories) => _controller.add(categories);

  Future<void> close() => _controller.close();

  @override
  Future<CategoryEntity> createWorkspaceCategory(CategoryEntity entity) async {
    if (error != null) throw error!;
    createdCategory = entity;
    return entity;
  }

  @override
  Future<void> updateWorkspaceCategory(CategoryEntity entity) async {
    if (error != null) throw error!;
    updatedCategory = entity;
  }

  @override
  Future<void> deleteWorkspaceCategory(String id) async {
    if (error != null) throw error!;
    deletedCategoryId = id;
  }
}

CategoryEntity _category(String id) => CategoryEntity(
  id: id,
  icon: '🏷️',
  isActive: true,
  type: TransactionType.expense,
  names: {'en': 'Category $id'},
);

void main() {
  group('Workspace Category UseCases', () {
    late _FakeCategoryRepository repository;

    setUp(() {
      repository = _FakeCategoryRepository();
    });

    tearDown(() async {
      await repository.close();
    });

    group('CreateWorkspaceCategoryUseCase', () {
      test('returns success when repository succeeds', () async {
        final useCase = CreateWorkspaceCategoryUseCase(repository);
        final category = _category('new');

        final result = await useCase(CreateWorkspaceCategoryParams(category));

        expect(result.isSuccess, isTrue);
        expect(repository.createdCategory?.id, 'new');
      });

      test('maps ArgumentError to ValidationFailure', () async {
        repository.error = ArgumentError('Invalid category name');
        final useCase = CreateWorkspaceCategoryUseCase(repository);

        final result = await useCase(
          CreateWorkspaceCategoryParams(_category('new')),
        );

        expect(result.isFailure, isTrue);
        expect(result.failureOrNull, isA<ValidationFailure>());
        expect(
          (result.failureOrNull as ValidationFailure).message,
          'Invalid category name',
        );
      });

      test('maps ArgumentError with null message to default message', () async {
        repository.error = ArgumentError();
        final useCase = CreateWorkspaceCategoryUseCase(repository);

        final result = await useCase(
          CreateWorkspaceCategoryParams(_category('new')),
        );

        expect(result.isFailure, isTrue);
        expect(result.failureOrNull, isA<ValidationFailure>());
        expect(
          (result.failureOrNull as ValidationFailure).message,
          'Invalid category data',
        );
      });

      test('maps generic error to UnknownFailure', () async {
        repository.error = Exception('Network error');
        final useCase = CreateWorkspaceCategoryUseCase(repository);

        final result = await useCase(
          CreateWorkspaceCategoryParams(_category('new')),
        );

        expect(result.isFailure, isTrue);
        expect(result.failureOrNull, isA<UnknownFailure>());
      });

      test('preserves Failure if already a Failure', () async {
        repository.error = const AuthFailure(message: 'Not authenticated');
        final useCase = CreateWorkspaceCategoryUseCase(repository);

        final result = await useCase(
          CreateWorkspaceCategoryParams(_category('new')),
        );

        expect(result.isFailure, isTrue);
        expect(result.failureOrNull, isA<AuthFailure>());
      });
    });

    group('UpdateWorkspaceCategoryUseCase', () {
      test('returns success when repository succeeds', () async {
        final useCase = UpdateWorkspaceCategoryUseCase(repository);
        final category = _category('update');

        final result = await useCase(UpdateWorkspaceCategoryParams(category));

        expect(result.isSuccess, isTrue);
        expect(repository.updatedCategory?.id, 'update');
      });

      test('maps ArgumentError to ValidationFailure', () async {
        repository.error = ArgumentError('Invalid update');
        final useCase = UpdateWorkspaceCategoryUseCase(repository);

        final result = await useCase(
          UpdateWorkspaceCategoryParams(_category('update')),
        );

        expect(result.isFailure, isTrue);
        expect(result.failureOrNull, isA<ValidationFailure>());
      });

      test('maps generic error to UnknownFailure', () async {
        repository.error = Exception('Update failed');
        final useCase = UpdateWorkspaceCategoryUseCase(repository);

        final result = await useCase(
          UpdateWorkspaceCategoryParams(_category('update')),
        );

        expect(result.isFailure, isTrue);
        expect(result.failureOrNull, isA<UnknownFailure>());
      });
    });

    group('DeleteWorkspaceCategoryUseCase', () {
      test('returns success when repository succeeds', () async {
        final useCase = DeleteWorkspaceCategoryUseCase(repository);

        final result = await useCase(
          DeleteWorkspaceCategoryParams('delete-me'),
        );

        expect(result.isSuccess, isTrue);
        expect(repository.deletedCategoryId, 'delete-me');
      });

      test('maps generic error to UnknownFailure', () async {
        repository.error = Exception('Delete failed');
        final useCase = DeleteWorkspaceCategoryUseCase(repository);

        final result = await useCase(
          DeleteWorkspaceCategoryParams('delete-me'),
        );

        expect(result.isFailure, isTrue);
        expect(result.failureOrNull, isA<UnknownFailure>());
      });

      test('preserves Failure if already a Failure', () async {
        repository.error = const AuthFailure(message: 'Not authenticated');
        final useCase = DeleteWorkspaceCategoryUseCase(repository);

        final result = await useCase(
          DeleteWorkspaceCategoryParams('delete-me'),
        );

        expect(result.isFailure, isTrue);
        expect(result.failureOrNull, isA<AuthFailure>());
      });
    });

    group('WatchWorkspaceCategoriesUseCase', () {
      test('exposes repository stream', () async {
        final useCase = WatchWorkspaceCategoriesUseCase(repository);

        final future = useCase(NoParam()).first;
        repository.emit([_category('cat-1'), _category('cat-2')]);

        final categories = await future;
        expect(categories.map((c) => c.id), ['cat-1', 'cat-2']);
      });

      test('emits multiple updates', () async {
        final useCase = WatchWorkspaceCategoriesUseCase(repository);
        final results = <List<CategoryEntity>>[];

        final subscription = useCase(NoParam()).listen(results.add);

        repository.emit([_category('cat-1')]);
        await pumpEventQueue();

        repository.emit([_category('cat-1'), _category('cat-2')]);
        await pumpEventQueue();

        await subscription.cancel();

        expect(results.length, 2);
        expect(results[0].length, 1);
        expect(results[1].length, 2);
      });
    });
  });
}
