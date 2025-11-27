import 'dart:async';

import 'package:expense_manager/core/auth/current_user.dart';

import 'package:expense_manager/core/workspace/current_workspace.dart';
import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:expense_manager/features/transactions/data/datasources/transactions_remote_data_source.dart';
import 'package:expense_manager/features/transactions/data/models/transaction_model.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:flutter_core/flutter_core.dart';

@LazySingleton(as: TransactionsRepository)
class TransactionsRepositoryImpl implements TransactionsRepository {
  TransactionsRepositoryImpl(
    this._remoteDataSource,
    this._currentUser,
    this._currentWorkspace,
  );

  final TransactionsRemoteDataSource _remoteDataSource;
  final CurrentUser _currentUser;
  final CurrentWorkspace _currentWorkspace;

  @override
  Stream<List<TransactionEntity>> watchAll() {
    return Stream<List<TransactionEntity>>.multi((controller) {
      StreamSubscription<CurrentWorkspaceSnapshot?>? workspaceSubscription;
      StreamSubscription<List<TransactionModel>>? remoteSubscription;

      void listenRemote() {
        remoteSubscription?.cancel();
        try {
          final context = _requireContext();
          remoteSubscription = _remoteDataSource
              .watchTransactions(context)
              .listen(
                (models) {
                  controller.add(_mapModels(models));
                },
                onError: (e, t) {
                  controller.addError(e, t);
                },
              );
        } catch (error, stackTrace) {
          controller.addError(error, stackTrace);
        }
      }

      workspaceSubscription = _currentWorkspace.watch().listen(
        (snapshot) {
          if (!controller.isClosed && snapshot != null) {
            listenRemote();
          }
        },
        onError: (e, t) {
          controller.addError(e, t);
        },
      );

      // Only listen if workspace is already available
      if (_currentWorkspace.now() != null) {
        listenRemote();
      }

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
  Future<List<TransactionEntity>> getAllOnce() async {
    final context = _requireContext();
    final models = await _remoteDataSource.fetchTransactionsOnce(context);
    return _mapModels(models);
  }

  @override
  Future<void> add(TransactionEntity entity) {
    final context = _requireContext();
    final id = entity.id.isEmpty
        ? _remoteDataSource.allocateId(context)
        : entity.id;
    final model = TransactionModel.fromEntity(entity.copyWith(id: id));
    return _remoteDataSource.upsert(context, model);
  }

  @override
  Future<void> update(TransactionEntity entity) {
    final context = _requireContext();
    final model = TransactionModel.fromEntity(entity);
    return _remoteDataSource.update(context, model);
  }

  @override
  Future<void> deleteById(String id) {
    final context = _requireContext();
    return _remoteDataSource.softDelete(context, id);
  }

  @override
  Future<void> shareToWorkspace({
    required TransactionEntity entity,
    required String workspaceId,
  }) async {
    final userSnapshot = _currentUser.now();
    final uid = userSnapshot?.uid;
    if (uid == null || uid.isEmpty) {
      throw AuthException('auth.required', tokenExpired: true);
    }

    final sourceContext = _requireContext();
    if (workspaceId == sourceContext.workspaceId) {
      return;
    }

    final targetContext = WorkspaceContext(
      userId: uid,
      workspaceId: workspaceId,
      type: WorkspaceType.workspace,
    );

    final newId = _remoteDataSource.allocateId(targetContext);
    final sharedEntity = entity.copyWith(
      id: newId,
      sharedFromWorkspaceId: sourceContext.workspaceId,
      sharedFromTransactionId: entity.id,
      sharedByUserId: uid,
    );
    final model = TransactionModel.fromEntity(sharedEntity);
    await _remoteDataSource.upsert(targetContext, model);
  }

  List<TransactionEntity> _mapModels(List<TransactionModel> models) {
    return models.map((model) => model.toEntity()).toList(growable: false);
  }

  WorkspaceContext _requireContext() {
    final snapshot = _currentUser.now();
    final uid = snapshot?.uid;
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
}
