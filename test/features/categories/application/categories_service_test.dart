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

  int fetchCount = 0;

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
  Stream<List<CategoryEntity>> watchWorkspaceCategories() =>
      const Stream<List<CategoryEntity>>.empty();

  @override
  Future<CategoryEntity> createWorkspaceCategory(CategoryEntity entity) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteWorkspaceCategory(String id) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateWorkspaceCategory(CategoryEntity entity) {
    throw UnimplementedError();
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
}
