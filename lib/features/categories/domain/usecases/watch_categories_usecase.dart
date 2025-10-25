import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/categories/domain/repositories/category_repository.dart';
import 'package:flutter_core/flutter_core.dart';

@singleton
class WatchCategoriesUseCase {
  WatchCategoriesUseCase(this._repository);

  final CategoryRepository _repository;

  Stream<List<CategoryEntity>> call(NoParam params) {
    return _repository.watchCombined();
  }
}
