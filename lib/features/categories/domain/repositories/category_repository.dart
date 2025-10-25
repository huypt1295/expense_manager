import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  Stream<List<CategoryEntity>> watchCombined();
  Future<List<CategoryEntity>> fetchCombined();

  Future<CategoryEntity> createUserCategory(CategoryEntity entity);
  Future<void> updateUserCategory(CategoryEntity entity);
  Future<void> deleteUserCategory(String id);
}
