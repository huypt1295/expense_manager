import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/categories/domain/repositories/category_repository.dart';
import 'package:expense_manager/features/categories/domain/usecases/load_categories_usecase.dart';
import 'package:flutter_core/flutter_core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';

class _FakeCategoryRepository implements CategoryRepository {
  Future<List<CategoryEntity>> Function()? fetchCombinedImpl;
  Stream<List<CategoryEntity>> Function()? watchCombinedImpl;

  @override
  Future<List<CategoryEntity>> fetchCombined() async {
    if (fetchCombinedImpl != null) return fetchCombinedImpl!();
    return const [];
  }

  @override
  Stream<List<CategoryEntity>> watchCombined() {
    if (watchCombinedImpl != null) return watchCombinedImpl!();
    return const Stream<List<CategoryEntity>>.empty();
  }

  @override
  Future<CategoryEntity> createUserCategory(CategoryEntity entity) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateUserCategory(CategoryEntity entity) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteUserCategory(String id) {
    throw UnimplementedError();
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
      repository.fetchCombinedImpl = () async => [
        CategoryEntity(
          id: 'id',
          icon: 'icon',
          isActive: true,
          type: TransactionType.expense,
          names: const {'en': 'Category'},
        ),
      ];

      final result = await useCase(NoParam());
      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, isNotEmpty);
    });

    test('maps unknown errors to UnknownFailure', () async {
      repository.fetchCombinedImpl = () async => throw Exception('boom');

      final result = await useCase(NoParam());
      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<UnknownFailure>());
    });
  });
}
