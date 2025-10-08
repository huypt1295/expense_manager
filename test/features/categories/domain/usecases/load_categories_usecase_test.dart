import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/categories/domain/repositories/category_repository.dart';
import 'package:expense_manager/features/categories/domain/usecases/load_categories_usecase.dart';
import 'package:flutter_core/flutter_core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';

class _FakeCategoryRepository implements CategoryRepository {
  Future<List<CategoryEntity>> Function()? fetchAllImpl;
  Stream<List<CategoryEntity>> Function()? watchAllImpl;

  @override
  Future<List<CategoryEntity>> fetchAll() async {
    if (fetchAllImpl != null) return fetchAllImpl!();
    return const [];
  }

  @override
  Stream<List<CategoryEntity>> watchAll() {
    if (watchAllImpl != null) return watchAllImpl!();
    return const Stream<List<CategoryEntity>>.empty();
  }
}

void main() {
  group('LoadCategoriesUseCase', () {
    late _FakeCategoryRepository repository;
    late LoadCategoriesUseCase useCase;

    setUp(() {
      repository = _FakeCategoryRepository();
      useCase = LoadCategoriesUseCase(repository);
    });

    test('returns success result on repository success', () async {
      repository.fetchAllImpl = () async => [
            CategoryEntity(
              id: 'id',
              icon: 'icon',
              isActive: true,
              names: const {'en': 'Category'},
            ),
          ];

      final result = await useCase(NoParam());
      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, isNotEmpty);
    });

    test('maps unknown errors to UnknownFailure', () async {
      repository.fetchAllImpl = () async => throw Exception('boom');

      final result = await useCase(NoParam());
      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<UnknownFailure>());
    });
  });
}
