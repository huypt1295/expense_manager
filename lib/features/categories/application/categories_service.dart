import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/categories/domain/usecases/create_user_category_usecase.dart';
import 'package:expense_manager/features/categories/domain/usecases/delete_user_category_usecase.dart';
import 'package:expense_manager/features/categories/domain/usecases/load_categories_usecase.dart';
import 'package:expense_manager/features/categories/domain/usecases/update_user_category_usecase.dart';
import 'package:expense_manager/features/categories/domain/usecases/watch_categories_usecase.dart';
import 'package:flutter_core/flutter_core.dart';

@lazySingleton
class CategoriesService {
  CategoriesService(
    this._loadCategoriesUseCase,
    this._watchCategoriesUseCase,
    this._createUserCategoryUseCase,
    this._updateUserCategoryUseCase,
    this._deleteUserCategoryUseCase,
  );

  final LoadCategoriesUseCase _loadCategoriesUseCase;
  final WatchCategoriesUseCase _watchCategoriesUseCase;
  final CreateUserCategoryUseCase _createUserCategoryUseCase;
  final UpdateUserCategoryUseCase _updateUserCategoryUseCase;
  final DeleteUserCategoryUseCase _deleteUserCategoryUseCase;

  List<CategoryEntity>? _cache;
  Future<List<CategoryEntity>>? _inFlight;

  Stream<List<CategoryEntity>> watchCategories() {
    return _watchCategoriesUseCase(NoParam());
  }

  Future<List<CategoryEntity>> getCategories({
    bool forceRefresh = false,
    TransactionType? type,
  }) async {
    final categories = await _fetchAll(forceRefresh: forceRefresh);
    if (type == null) {
      return categories;
    }
    return categories
        .where((category) => category.type == type)
        .toList(growable: false);
  }

  Future<CategoryEntity> createUserCategory(CategoryEntity entity) async {
    final result = await _createUserCategoryUseCase(
      CreateUserCategoryParams(entity),
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
    final result = await _updateUserCategoryUseCase(
      UpdateUserCategoryParams(entity),
    );
    return result.fold(
      ok: (_) {
        clearCache();
        return;
      },
      err: (failure) => throw failure,
    );
  }

  Future<void> deleteUserCategory(String id) async {
    final result = await _deleteUserCategoryUseCase(
      DeleteUserCategoryParams(id),
    );
    return result.fold(
      ok: (_) {
        clearCache();
        return;
      },
      err: (failure) => throw failure,
    );
  }

  void clearCache() {
    _cache = null;
  }

  Future<List<CategoryEntity>> _fetchAll({required bool forceRefresh}) async {
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
      return await future;
    } finally {
      _inFlight = null;
    }
  }
}
