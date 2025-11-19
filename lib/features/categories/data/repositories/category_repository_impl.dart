import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/core/workspace/current_workspace.dart';
import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:expense_manager/features/categories/data/datasources/category_remote_data_source.dart';
import 'package:expense_manager/features/categories/data/models/category_model.dart';
import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/categories/domain/repositories/category_repository.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(
    this._remoteDataSource,
    this._currentUser,
    this._currentWorkspace,
  );

  final CategoryRemoteDataSource _remoteDataSource;
  final CurrentUser _currentUser;
  final CurrentWorkspace _currentWorkspace;

  @override
  Stream<List<CategoryEntity>> watchCombined() {
    final uid = _currentUser.now()?.uid;
    final defaultStream = _remoteDataSource.watchDefault();
    final userStream = (uid == null || uid.isEmpty)
        ? Stream<List<CategoryModel>>.value(const <CategoryModel>[])
        : _remoteDataSource.watchForUser(uid);

    return Rx.combineLatest2<
          List<CategoryModel>,
          List<CategoryModel>,
          List<CategoryEntity>
        >(
          defaultStream,
          userStream,
          (defaults, users) => _mapModelsToEntities(defaults, users),
        )
        .map(List<CategoryEntity>.unmodifiable);
  }

  @override
  Future<List<CategoryEntity>> fetchCombined() async {
    final uid = _currentUser.now()?.uid;
    final defaultModels = await _remoteDataSource.fetchDefault();
    final userModels = (uid == null || uid.isEmpty)
        ? const <CategoryModel>[]
        : await _remoteDataSource.fetchForUser(uid);
    return List<CategoryEntity>.unmodifiable(
      _mapModelsToEntities(defaultModels, userModels),
    );
  }

  @override
  Future<CategoryEntity> createUserCategory(CategoryEntity entity) async {
    final uid = _requireUid();
    if (!entity.isCustom) {
      throw ArgumentError.value(
        entity.isCustom,
        'isCustom',
        'Only custom categories can be created for users.',
      );
    }

    final model = CategoryModel.fromEntity(
      entity.copyWith(
        id: entity.id.isEmpty ? '' : entity.id,
        ownerId: uid,
        isArchived: false,
        isActive: entity.isActive,
      ),
    );

    final created = await _remoteDataSource.createForUser(uid, model);
    return created.toEntity();
  }

  @override
  Future<void> updateUserCategory(CategoryEntity entity) {
    final uid = _requireUid();
    if (!entity.isCustom) {
      throw ArgumentError.value(
        entity.isCustom,
        'isCustom',
        'Default categories cannot be updated by users.',
      );
    }

    final model = CategoryModel.fromEntity(entity.copyWith(ownerId: uid));
    return _remoteDataSource.updateForUser(uid, model);
  }

  @override
  Future<void> deleteUserCategory(String id) {
    final uid = _requireUid();
    return _remoteDataSource.deleteForUser(uid, id);
  }

  List<CategoryEntity> _mapModelsToEntities(
    List<CategoryModel> defaultModels,
    List<CategoryModel> userModels,
  ) {
    final defaults = defaultModels
        .where(_isVisibleModel)
        .map((model) => model.toEntity())
        .toList(growable: false);

    final users = userModels
        .where(_isVisibleModel)
        .map((model) => model.toEntity())
        .toList(growable: false);

    defaults.sort(_sortDefaultCategories);
    users.sort(_sortUserCategories);

    return <CategoryEntity>[...defaults, ...users];
  }

  bool _isVisibleModel(CategoryModel model) {
    if (!model.isActive) {
      return false;
    }
    if (model.isArchived == true) {
      return false;
    }
    if (model.name.values.every((value) => (value).trim().isEmpty)) {
      return false;
    }
    return true;
  }

  int _sortDefaultCategories(CategoryEntity a, CategoryEntity b) {
    final orderA = a.sortOrder;
    final orderB = b.sortOrder;
    if (orderA != null && orderB != null) {
      final comparison = orderA.compareTo(orderB);
      if (comparison != 0) {
        return comparison;
      }
    } else if (orderA != null) {
      return -1;
    } else if (orderB != null) {
      return 1;
    }
    return a.nameForLocale('en').compareTo(b.nameForLocale('en'));
  }

  int _sortUserCategories(CategoryEntity a, CategoryEntity b) {
    final createdA = a.createdAt;
    final createdB = b.createdAt;
    if (createdA != null && createdB != null) {
      final comparison = createdA.compareTo(createdB);
      if (comparison != 0) {
        return comparison;
      }
    }
    return a.nameForLocale('en').compareTo(b.nameForLocale('en'));
  }

  String _requireUid() {
    final snapshot = _currentUser.now();
    final uid = snapshot?.uid;
    if (uid == null || uid.isEmpty) {
      throw AuthException('auth.required', tokenExpired: true);
    }
    return uid;
  }

  WorkspaceContext _requireWorkspaceContext() {
    final snapshot = _currentWorkspace.now();
    if (snapshot == null) {
      throw Exception('No workspace selected');
    }
    final uid = _currentUser.now()?.uid;
    if (uid == null || uid.isEmpty) {
      throw AuthException('auth.required', tokenExpired: true);
    }
    return WorkspaceContext(
      userId: uid,
      workspaceId: snapshot.id,
      type: snapshot.type,
    );
  }

  // ========== Workspace-aware methods ==========

  @override
  Stream<List<CategoryEntity>> watchWorkspaceCategories() {
    final context = _requireWorkspaceContext();
    final defaultStream = _remoteDataSource.watchDefault();
    final workspaceStream = _remoteDataSource.watchForWorkspace(context);

    return Rx.combineLatest2<
          List<CategoryModel>,
          List<CategoryModel>,
          List<CategoryEntity>
        >(
          defaultStream,
          workspaceStream,
          (defaults, workspace) => _mapModelsToEntities(defaults, workspace),
        )
        .map(List<CategoryEntity>.unmodifiable);
  }

  @override
  Future<List<CategoryEntity>> fetchWorkspaceCategories() async {
    final context = _requireWorkspaceContext();
    final defaultModels = await _remoteDataSource.fetchDefault();
    final workspaceModels = await _remoteDataSource.fetchForWorkspace(context);
    return List<CategoryEntity>.unmodifiable(
      _mapModelsToEntities(defaultModels, workspaceModels),
    );
  }

  @override
  Future<CategoryEntity> createWorkspaceCategory(CategoryEntity entity) async {
    final context = _requireWorkspaceContext();
    if (!entity.isCustom) {
      throw ArgumentError.value(
        entity.isCustom,
        'isCustom',
        'Only custom categories can be created for workspaces.',
      );
    }

    final model = CategoryModel.fromEntity(
      entity.copyWith(
        id: entity.id.isEmpty ? '' : entity.id,
        ownerId: context.userId,
        isArchived: false,
        isActive: entity.isActive,
      ),
    );

    final created = await _remoteDataSource.createForWorkspace(context, model);
    return created.toEntity();
  }

  @override
  Future<void> updateWorkspaceCategory(CategoryEntity entity) {
    final context = _requireWorkspaceContext();
    if (!entity.isCustom) {
      throw ArgumentError.value(
        entity.isCustom,
        'isCustom',
        'Default categories cannot be updated.',
      );
    }

    final model = CategoryModel.fromEntity(entity);
    return _remoteDataSource.updateForWorkspace(context, model);
  }

  @override
  Future<void> deleteWorkspaceCategory(String id) {
    final context = _requireWorkspaceContext();
    return _remoteDataSource.deleteForWorkspace(context, id);
  }
}
