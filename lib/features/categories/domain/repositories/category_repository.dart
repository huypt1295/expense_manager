import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';

abstract interface class CategoryRepository {
  Stream<List<CategoryEntity>> watchCombined();
  Future<List<CategoryEntity>> fetchCombined();
  Stream<List<CategoryEntity>> watchWorkspaceCategories();
  Future<List<CategoryEntity>> fetchWorkspaceCategories();
  Future<CategoryEntity> createWorkspaceCategory(CategoryEntity entity);
  Future<void> updateWorkspaceCategory(CategoryEntity entity);
  Future<void> deleteWorkspaceCategory(String id);
}
