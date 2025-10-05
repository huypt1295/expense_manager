import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  Stream<List<CategoryEntity>> watchAll();
  Future<List<CategoryEntity>> fetchAll();
}
