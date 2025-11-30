import 'dart:async';

import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/categories/application/categories_service.dart';
import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/categories/domain/repositories/category_repository.dart';
import 'package:expense_manager/features/categories/domain/usecases/create_workspace_category_usecase.dart';
import 'package:expense_manager/features/categories/domain/usecases/delete_workspace_category_usecase.dart';
import 'package:expense_manager/features/categories/domain/usecases/load_categories_usecase.dart';
import 'package:expense_manager/features/categories/domain/usecases/update_workspace_category_usecase.dart';
import 'package:expense_manager/features/categories/domain/usecases/watch_workspace_categories_usecase.dart';
import 'package:flutter_core/flutter_core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';

class _FakeCategoryRepository implements CategoryRepository {
  Future<List<CategoryEntity>> Function()? fetchCombinedImpl;
  Stream<List<CategoryEntity>> Function()? watchCombinedImpl;
  Stream<List<CategoryEntity>> Function()? watchWorkspaceCategoriesImpl;

  int fetchCount = 0;
  Object? createError;
  Object? updateError;
  Object? deleteError;

  CategoryEntity? createdCategory;
  CategoryEntity? updatedCategory;
  String? deletedCategoryId;

  @override
  Future<List<CategoryEntity>> fetchCombined() async {
    fetchCount += 1;
    if (fetchCombinedImpl != null) {
      return await fetchCombinedImpl!();
    }
    return const <CategoryEntity>[];
  }

  @override
  Stream<List<CategoryEntity>> watchCombined() {
    if (watchCombinedImpl != null) {
      return watchCombinedImpl!();
    }
    return const Stream<List<CategoryEntity>>.empty();
  }

  @override
  Future<List<CategoryEntity>> fetchWorkspaceCategories() async => const [];

  @override
  Stream<List<CategoryEntity>> watchWorkspaceCategories() {
    if (watchWorkspaceCategoriesImpl != null) {
      return watchWorkspaceCategoriesImpl!();
    }
    return const Stream<List<CategoryEntity>>.empty();
  }

  @override
  Future<CategoryEntity> createWorkspaceCategory(CategoryEntity entity) async {
    if (createError != null) throw createError!;
    createdCategory = entity;
    return entity;
  }

  @override
  Future<void> deleteWorkspaceCategory(String id) async {
    if (deleteError != null) throw deleteError!;
    deletedCategoryId = id;
  }

  @override
  Future<void> updateWorkspaceCategory(CategoryEntity entity) async {
    if (updateError != null) throw updateError!;
    updatedCategory = entity;
  }
}

CategoryEntity _category(String id, {bool isActive = true, int? sortOrder}) =>
    CategoryEntity(
      id: id,
      icon: 'icon',
      isActive: isActive,
      type: TransactionType.expense,
      names: {'en': 'Category $id'},
      sortOrder: sortOrder,
      isCustom: true,
    );

void main() {
  group('CategoriesService caching', () {
    late _FakeCategoryRepository repository;
    late CategoriesService service;

    setUp(() {
      repository = _FakeCategoryRepository();
      service = CategoriesService(
        LoadCategoriesUseCase(repository),
        WatchWorkspaceCategoriesUseCase(repository),
        CreateWorkspaceCategoryUseCase(repository),
        UpdateWorkspaceCategoryUseCase(repository),
        DeleteWorkspaceCategoryUseCase(repository),
      );
    });

    test('returns cached categories without re-fetching', () async {
      repository.fetchCombinedImpl = () async => [_category('1')];

      final first = await service.getCategories();
      expect(first, hasLength(1));
      expect(repository.fetchCount, 1);

      repository.fetchCombinedImpl = () async => [_category('2')];

      final second = await service.getCategories();
      expect(repository.fetchCount, 1, reason: 'should reuse cache');
      expect(identical(first, second), isTrue, reason: 'returns cached list');
      expect(second, contains(_category('1')));
    });

    test('forceRefresh bypasses cache', () async {
      repository.fetchCombinedImpl = () async => [_category('1')];
      await service.getCategories();
      expect(repository.fetchCount, 1);

      repository.fetchCombinedImpl = () async => [_category('2')];
      final refreshed = await service.getCategories(forceRefresh: true);

      expect(repository.fetchCount, 2);
      expect(refreshed, contains(_category('2')));
    });

    test('concurrent calls share in-flight future', () async {
      final completer = Completer<List<CategoryEntity>>();
      repository.fetchCombinedImpl = () => completer.future;

      final first = service.getCategories();
      final second = service.getCategories();

      expect(
        repository.fetchCount,
        1,
        reason: 'second call should reuse future',
      );

      completer.complete([_category('shared')]);

      final results = await Future.wait([first, second]);
      expect(identical(results[0], results[1]), isTrue);
      expect(results[0], contains(_category('shared')));
    });
  });

  group('CategoriesService watchCategories', () {
    late _FakeCategoryRepository repository;
    late CategoriesService service;

    setUp(() {
      repository = _FakeCategoryRepository();
      service = CategoriesService(
        LoadCategoriesUseCase(repository),
        WatchWorkspaceCategoriesUseCase(repository),
        CreateWorkspaceCategoryUseCase(repository),
        UpdateWorkspaceCategoryUseCase(repository),
        DeleteWorkspaceCategoryUseCase(repository),
      );
    });

    test('returns stream from watchWorkspaceCategories', () async {
      final controller = StreamController<List<CategoryEntity>>.broadcast();
      repository.watchWorkspaceCategoriesImpl = () => controller.stream;

      final stream = service.watchCategories();
      final future = stream.first;

      controller.add([_category('cat-1'), _category('cat-2')]);

      final result = await future;
      expect(result.length, 2);
      expect(result[0].id, 'cat-1');

      await controller.close();
    });
  });

  group('CategoriesService type filtering', () {
    late _FakeCategoryRepository repository;
    late CategoriesService service;

    setUp(() {
      repository = _FakeCategoryRepository();
      service = CategoriesService(
        LoadCategoriesUseCase(repository),
        WatchWorkspaceCategoriesUseCase(repository),
        CreateWorkspaceCategoryUseCase(repository),
        UpdateWorkspaceCategoryUseCase(repository),
        DeleteWorkspaceCategoryUseCase(repository),
      );
    });

    test('filters categories by expense type', () async {
      repository.fetchCombinedImpl = () async => [
        CategoryEntity(
          id: 'expense-1',
          icon: 'icon',
          isActive: true,
          type: TransactionType.expense,
          names: {'en': 'Expense Cat'},
        ),
        CategoryEntity(
          id: 'income-1',
          icon: 'icon',
          isActive: true,
          type: TransactionType.income,
          names: {'en': 'Income Cat'},
        ),
      ];

      final result = await service.getCategories(type: TransactionType.expense);

      expect(result.length, 1);
      expect(result[0].id, 'expense-1');
      expect(result[0].type, TransactionType.expense);
    });

    test('filters categories by income type', () async {
      repository.fetchCombinedImpl = () async => [
        CategoryEntity(
          id: 'expense-1',
          icon: 'icon',
          isActive: true,
          type: TransactionType.expense,
          names: {'en': 'Expense Cat'},
        ),
        CategoryEntity(
          id: 'income-1',
          icon: 'icon',
          isActive: true,
          type: TransactionType.income,
          names: {'en': 'Income Cat'},
        ),
      ];

      final result = await service.getCategories(type: TransactionType.income);

      expect(result.length, 1);
      expect(result[0].id, 'income-1');
      expect(result[0].type, TransactionType.income);
    });

    test('returns all categories when type is null', () async {
      repository.fetchCombinedImpl = () async => [
        CategoryEntity(
          id: 'expense-1',
          icon: 'icon',
          isActive: true,
          type: TransactionType.expense,
          names: {'en': 'Expense Cat'},
        ),
        CategoryEntity(
          id: 'income-1',
          icon: 'icon',
          isActive: true,
          type: TransactionType.income,
          names: {'en': 'Income Cat'},
        ),
      ];

      final result = await service.getCategories(type: null);

      expect(result.length, 2);
    });
  });

  group('CategoriesService CRUD operations', () {
    late _FakeCategoryRepository repository;
    late CategoriesService service;

    setUp(() {
      repository = _FakeCategoryRepository();
      service = CategoriesService(
        LoadCategoriesUseCase(repository),
        WatchWorkspaceCategoriesUseCase(repository),
        CreateWorkspaceCategoryUseCase(repository),
        UpdateWorkspaceCategoryUseCase(repository),
        DeleteWorkspaceCategoryUseCase(repository),
      );
    });

    test('createUserCategory creates and clears cache', () async {
      // Load and cache categories
      repository.fetchCombinedImpl = () async => [_category('cat-1')];
      await service.getCategories();
      expect(repository.fetchCount, 1);

      // Create new category
      final newCategory = _category('new-cat');
      final result = await service.createUserCategory(newCategory);

      expect(result.id, 'new-cat');
      expect(repository.createdCategory, newCategory);

      // Update repository data
      repository.fetchCombinedImpl = () async => [
        _category('cat-1'),
        _category('new-cat'),
      ];

      // Should reload from repository (cache cleared)
      final categories = await service.getCategories();
      expect(repository.fetchCount, 2);
      expect(categories.length, 2);
    });

    test('createUserCategory throws on error', () async {
      repository.createError = const ValidationFailure(message: 'Invalid');

      expect(
        () => service.createUserCategory(_category('bad')),
        throwsA(isA<ValidationFailure>()),
      );
    });

    test('updateUserCategory updates and clears cache', () async {
      repository.fetchCombinedImpl = () async => [_category('cat-1')];
      await service.getCategories();
      expect(repository.fetchCount, 1);

      final updated = _category('cat-1');
      await service.updateUserCategory(updated);

      expect(repository.updatedCategory, updated);

      repository.fetchCombinedImpl = () async => [_category('cat-1-updated')];

      final categories = await service.getCategories();
      expect(repository.fetchCount, 2);
      expect(categories.length, 1);
    });

    test('updateUserCategory throws on error', () async {
      repository.updateError = const ValidationFailure(
        message: 'Update failed',
      );

      expect(
        () => service.updateUserCategory(_category('bad')),
        throwsA(isA<ValidationFailure>()),
      );
    });

    test('deleteUserCategory deletes and clears cache', () async {
      repository.fetchCombinedImpl = () async => [
        _category('cat-1'),
        _category('cat-2'),
      ];
      await service.getCategories();
      expect(repository.fetchCount, 1);

      await service.deleteUserCategory('cat-1');

      expect(repository.deletedCategoryId, 'cat-1');

      repository.fetchCombinedImpl = () async => [_category('cat-2')];

      final categories = await service.getCategories();
      expect(repository.fetchCount, 2);
      expect(categories.length, 1);
    });

    test('deleteUserCategory throws on error', () async {
      repository.deleteError = const ValidationFailure(
        message: 'Cannot delete',
      );

      expect(
        () => service.deleteUserCategory('protected'),
        throwsA(isA<ValidationFailure>()),
      );
    });
  });

  group('CategoriesService clearCache', () {
    late _FakeCategoryRepository repository;
    late CategoriesService service;

    setUp(() {
      repository = _FakeCategoryRepository();
      service = CategoriesService(
        LoadCategoriesUseCase(repository),
        WatchWorkspaceCategoriesUseCase(repository),
        CreateWorkspaceCategoryUseCase(repository),
        UpdateWorkspaceCategoryUseCase(repository),
        DeleteWorkspaceCategoryUseCase(repository),
      );
    });

    test('clearCache forces reload on next getCategories', () async {
      repository.fetchCombinedImpl = () async => [_category('cat-1')];
      await service.getCategories();
      expect(repository.fetchCount, 1);

      service.clearCache();

      repository.fetchCombinedImpl = () async => [_category('cat-2')];

      final result = await service.getCategories();
      expect(repository.fetchCount, 2);
      expect(result[0].id, 'cat-2');
    });
  });
}
