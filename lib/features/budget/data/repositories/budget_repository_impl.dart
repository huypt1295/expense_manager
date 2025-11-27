import 'dart:async';

import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/core/workspace/current_workspace.dart';
import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:expense_manager/features/budget/data/datasources/budget_remote_data_source.dart';
import 'package:expense_manager/features/budget/data/models/budget_model.dart';
import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_manager/features/budget/domain/repositories/budget_repository.dart';
import 'package:flutter_core/flutter_core.dart';

@LazySingleton(as: BudgetRepository)
class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl(
    this._remoteDataSource,
    this._currentUser,
    this._currentWorkspace,
  );

  final BudgetRemoteDataSource _remoteDataSource;
  final CurrentUser _currentUser;
  final CurrentWorkspace _currentWorkspace;

  @override
  Stream<List<BudgetEntity>> watchAll() {
    return Stream<List<BudgetEntity>>.multi((controller) {
      StreamSubscription<CurrentWorkspaceSnapshot?>? workspaceSubscription;
      StreamSubscription<List<BudgetModel>>? remoteSubscription;

      void listenRemote() {
        remoteSubscription?.cancel();
        try {
          final context = _requireContext();
          remoteSubscription = _remoteDataSource.watchBudgets(context).listen((
            models,
          ) {
            controller.add(
              models.map((model) => model.toEntity()).toList(growable: false),
            );
          }, onError: controller.addError);
        } catch (error, stackTrace) {
          controller.addError(error, stackTrace);
        }
      }

      workspaceSubscription = _currentWorkspace.watch().listen((_) {
        if (!controller.isClosed) {
          listenRemote();
        }
      }, onError: controller.addError);

      listenRemote();

      controller
        ..onPause = () {
          remoteSubscription?.pause();
        }
        ..onResume = () {
          remoteSubscription?.resume();
        }
        ..onCancel = () async {
          await remoteSubscription?.cancel();
          await workspaceSubscription?.cancel();
        };
    });
  }

  @override
  Future<void> add(BudgetEntity entity) async {
    final context = _requireContext();
    _assertCanManageCurrentWorkspace();
    final id = entity.id.isEmpty
        ? _remoteDataSource.allocateId(context)
        : entity.id;
    final model = BudgetModel.fromEntity(entity.copyWith(id: id));
    await _remoteDataSource.upsert(context, model);
  }

  @override
  Future<void> update(BudgetEntity entity) {
    final context = _requireContext();
    _assertCanManageCurrentWorkspace();
    final model = BudgetModel.fromEntity(entity);
    return _remoteDataSource.update(context, model);
  }

  @override
  Future<void> deleteById(String id) {
    final context = _requireContext();
    _assertCanManageCurrentWorkspace();
    return _remoteDataSource.delete(context, id);
  }

  WorkspaceContext _requireContext() {
    final userSnapshot = _currentUser.now();
    final uid = userSnapshot?.uid;
    if (uid == null || uid.isEmpty) {
      throw AuthException('auth.required', tokenExpired: true);
    }

    final workspace = _currentWorkspace.now();
    if (workspace == null) {
      return WorkspaceContext(
        userId: uid,
        workspaceId: uid,
        type: WorkspaceType.personal,
      );
    }
    return workspace.toContext(userId: uid);
  }

  void _assertCanManageCurrentWorkspace() {
    final snapshot = _currentWorkspace.now();
    if (snapshot == null || snapshot.isPersonal) {
      return;
    }
    final role = (snapshot.role ?? '').toLowerCase().trim();
    if (role == 'owner' || role == 'editor') {
      return;
    }
    throw AuthException('workspace.permission.denied');
  }
}
