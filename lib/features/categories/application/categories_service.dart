import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/categories/domain/usecases/load_categories_usecase.dart';
import 'package:flutter_core/flutter_core.dart';

@lazySingleton
class CategoriesService {
  CategoriesService(this._loadCategoriesUseCase);

  final LoadCategoriesUseCase _loadCategoriesUseCase;

  List<CategoryEntity>? _cache;
  Future<List<CategoryEntity>>? _inFlight;

  Future<List<CategoryEntity>> getCategories({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = _cache;
      if (cached != null) {
        return cached;
      }
      final inFlight = _inFlight;
      if (inFlight != null) {
        return inFlight;
      }
    }

    final future = _loadCategoriesUseCase(NoParam()).then((result) {
      return result.fold(
        ok: (items) {
          _cache = items;
          return items;
        },
        err: (failure) => throw failure,
      );
    });

    _inFlight = future;
    try {
      final categories = await future;
      return categories;
    } finally {
      _inFlight = null;
    }
  }

  void clearCache() {
    _cache = null;
  }
}
