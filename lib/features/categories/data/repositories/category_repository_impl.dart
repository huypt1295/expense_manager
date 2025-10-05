import 'package:expense_manager/features/categories/data/datasources/category_remote_data_source.dart';
import 'package:expense_manager/features/categories/data/models/category_model.dart';
import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/categories/domain/repositories/category_repository.dart';
import 'package:flutter_core/flutter_core.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._remoteDataSource);

  final CategoryRemoteDataSource _remoteDataSource;

  @override
  Stream<List<CategoryEntity>> watchAll() {
    return _remoteDataSource.watchAll().map((models) {
      return _mapModelsToEntities(models);
    });
  }

  @override
  Future<List<CategoryEntity>> fetchAll() async {
    final models = await _remoteDataSource.fetchAll();
    return _mapModelsToEntities(models);
  }

  List<CategoryEntity> _mapModelsToEntities(List<CategoryModel> models) {
    final entities = models
        .where((model) => model.isActive)
        .map((model) => model.toEntity())
        .toList(growable: false);
    entities.sort((a, b) {
      final orderA = a.sortOrder;
      final orderB = b.sortOrder;
      if (orderA != null && orderB != null) {
        return orderA.compareTo(orderB);
      }
      if (orderA != null) {
        return -1;
      }
      if (orderB != null) {
        return 1;
      }
      return a.id.compareTo(b.id);
    });
    return entities;
  }
}
