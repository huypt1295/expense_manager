import 'dart:async';

import 'package:expense_manager/features/categories/application/categories_service.dart';
import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/categories/domain/repositories/category_repository.dart';
import 'package:expense_manager/features/categories/domain/usecases/load_categories_usecase.dart';
import 'package:flutter_core/flutter_core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';

class _FakeCategoryRepository implements CategoryRepository {
  Future<List<CategoryEntity>> Function()? fetchAllImpl;
  Stream<List<CategoryEntity>> Function()? watchAllImpl;

  int fetchCount = 0;

  @override
  Future<List<CategoryEntity>> fetchAll() async {
    fetchCount += 1;
    if (fetchAllImpl != null) {
      return await fetchAllImpl!();
    }
    return const <CategoryEntity>[];
  }

  @override
  Stream<List<CategoryEntity>> watchAll() {
    if (watchAllImpl != null) {
      return watchAllImpl!();
    }
    return const Stream<List<CategoryEntity>>.empty();
  }
}

CategoryEntity _category(String id, {bool isActive = true, int? sortOrder}) => CategoryEntity(
      id: id,
      icon: 'icon',
      isActive: isActive,
      names: {'en': 'Category $id'},
      sortOrder: sortOrder,
    );

void main() {
  group('CategoriesService caching', () {
    late _FakeCategoryRepository repository;
    late CategoriesService service;

    setUp(() {
      repository = _FakeCategoryRepository();
      service = CategoriesService(LoadCategoriesUseCase(repository));
    });

    test('returns cached categories without re-fetching', () async {
      repository.fetchAllImpl = () async => [_category('1')];

      final first = await service.getCategories();
      expect(first, hasLength(1));
      expect(repository.fetchCount, 1);

      repository.fetchAllImpl = () async => [_category('2')];

      final second = await service.getCategories();
      expect(repository.fetchCount, 1, reason: 'should reuse cache');
      expect(identical(first, second), isTrue, reason: 'returns cached list');
      expect(second, contains(_category('1')));
    });

    test('forceRefresh bypasses cache', () async {
      repository.fetchAllImpl = () async => [_category('1')];
      await service.getCategories();
      expect(repository.fetchCount, 1);

      repository.fetchAllImpl = () async => [_category('2')];
      final refreshed = await service.getCategories(forceRefresh: true);

      expect(repository.fetchCount, 2);
      expect(refreshed, contains(_category('2')));
    });

    test('concurrent calls share in-flight future', () async {
      final completer = Completer<List<CategoryEntity>>();
      repository.fetchAllImpl = () => completer.future;

      final first = service.getCategories();
      final second = service.getCategories();

      expect(repository.fetchCount, 1, reason: 'second call should reuse future');

      completer.complete([_category('shared')]);

      final results = await Future.wait([first, second]);
      expect(identical(results[0], results[1]), isTrue);
      expect(results[0], contains(_category('shared')));
    });
  });
}
