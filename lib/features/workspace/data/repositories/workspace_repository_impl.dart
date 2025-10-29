import 'dart:async';

import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/features/workspace/data/datasources/workspace_remote_data_source.dart';
import 'package:expense_manager/features/workspace/data/models/workspace_model.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_entity.dart';
import 'package:expense_manager/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:flutter_core/flutter_core.dart';

@LazySingleton(as: WorkspaceRepository)
class WorkspaceRepositoryImpl implements WorkspaceRepository {
  WorkspaceRepositoryImpl(this._remoteDataSource, this._currentUser);

  final WorkspaceRemoteDataSource _remoteDataSource;
  final CurrentUser _currentUser;

  @override
  Stream<List<WorkspaceEntity>> watchAll() {
    return Stream<List<WorkspaceEntity>>.multi((controller) {
      StreamSubscription<CurrentUserSnapshot?>? userSubscription;
      StreamSubscription<List<WorkspaceModel>>? remoteSubscription;

      Future<void> listenRemote(CurrentUserSnapshot snapshot) async {
        await remoteSubscription?.cancel();
        final uid = snapshot.uid;
        if (uid == null || uid.isEmpty) {
          controller.add(const <WorkspaceEntity>[]);
          return;
        }
        remoteSubscription = _remoteDataSource.watchMemberships(uid).listen(
          (models) {
            final personal = _personalWorkspace(snapshot);
            final households = models.map((model) => model.toEntity()).toList();
            controller.add(<WorkspaceEntity>[personal, ...households]);
          },
          onError: controller.addError,
        );
      }

      userSubscription = _currentUser.watch().listen(
        (snapshot) {
          if (snapshot == null) {
            controller.add(const <WorkspaceEntity>[]);
            return;
          }
          unawaited(listenRemote(snapshot));
        },
        onError: controller.addError,
      );

      final initial = _currentUser.now();
      if (initial != null) {
        unawaited(listenRemote(initial));
      } else {
        controller.add(const <WorkspaceEntity>[]);
      }

      controller.onCancel = () async {
        await remoteSubscription?.cancel();
        await userSubscription?.cancel();
      };
    });
  }

  WorkspaceEntity _personalWorkspace(CurrentUserSnapshot snapshot) {
    final uid = snapshot.uid ?? '';
    final displayName = snapshot.displayName?.trim();
    final name = (displayName != null && displayName.isNotEmpty)
        ? displayName
        : 'Personal';
    return WorkspaceEntity.personal(id: uid, name: name);
  }
}
