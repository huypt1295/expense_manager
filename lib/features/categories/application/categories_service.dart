import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/categories/domain/usecases/create_workspace_category_usecase.dart';
import 'package:expense_manager/features/categories/domain/usecases/delete_workspace_category_usecase.dart';
import 'package:expense_manager/features/categories/domain/usecases/load_categories_usecase.dart';
import 'package:expense_manager/features/categories/domain/usecases/update_workspace_category_usecase.dart';
import 'package:expense_manager/features/categories/domain/usecases/watch_workspace_categories_usecase.dart';
import 'package:flutter_core/flutter_core.dart';

@lazySingleton
class CategoriesService {
  CategoriesService(
    this._loadCategoriesUseCase,
    this._watchWorkspaceCategoriesUseCase,
    this._createWorkspaceCategoryUseCase,
    this._updateWorkspaceCategoryUseCase,
    this._deleteWorkspaceCategoryUseCase,
  );

  final LoadCategoriesUseCase _loadCategoriesUseCase;
  final WatchWorkspaceCategoriesUseCase _watchWorkspaceCategoriesUseCase;
  final CreateWorkspaceCategoryUseCase _createWorkspaceCategoryUseCase;
  final UpdateWorkspaceCategoryUseCase _updateWorkspaceCategoryUseCase;
  final DeleteWorkspaceCategoryUseCase _deleteWorkspaceCategoryUseCase;

  List<CategoryEntity>? _cache;
  Future<List<CategoryEntity>>? _inFlight;

  Stream<List<CategoryEntity>> watchCategories() {
    return _watchWorkspaceCategoriesUseCase(NoParam());
  }

  Future<List<CategoryEntity>> getCategories({
    bool forceRefresh = false,
    TransactionType? type,
  }) async {
    if (!forceRefresh && _cache != null) {
      return _filterByType(_cache!, type);
    }

    _inFlight ??= _loadCategoriesUseCase(NoParam()).then((result) {
      return result.fold(
        ok: (categories) {
          _cache = categories;
          _inFlight = null;
          return categories;
        },
        err: (failure) => throw failure,
      );
    });

    final categories = await _inFlight!;
    return _filterByType(categories, type);
  }

  Future<CategoryEntity> createUserCategory(CategoryEntity entity) async {
    final result = await _createWorkspaceCategoryUseCase(
      CreateWorkspaceCategoryParams(entity),
    );
    return result.fold(
      ok: (created) {
        clearCache();
        return created;
      },
      err: (failure) => throw failure,
    );
  }

  Future<void> updateUserCategory(CategoryEntity entity) async {
    final result = await _updateWorkspaceCategoryUseCase(
      UpdateWorkspaceCategoryParams(entity),
    );
    return result.fold(
      ok: (_) {
        clearCache();
      },
      err: (failure) => throw failure,
    );
  }

  Future<void> deleteUserCategory(String id) async {
    final result = await _deleteWorkspaceCategoryUseCase(
      DeleteWorkspaceCategoryParams(id),
    );
    return result.fold(
      ok: (_) {
        clearCache();
      },
      err: (failure) => throw failure,
    );
  }

  void clearCache() {
    _cache = null;
  }

  List<CategoryEntity> _filterByType(
    List<CategoryEntity> categories,
    TransactionType? type,
  ) {
    if (type == null) {
      return categories;
    }
    return categories
        .where((category) => category.type == type)
        .toList(growable: false);
  }
}
