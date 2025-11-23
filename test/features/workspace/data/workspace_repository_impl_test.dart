import 'dart:async';

import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:expense_manager/features/workspace/data/datasources/workspace_remote_data_source.dart';
import 'package:expense_manager/features/workspace/data/models/workspace_model.dart';
import 'package:expense_manager/features/workspace/data/repositories/workspace_repository_impl.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_entity.dart';
import 'package:expense_manager/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:flutter_core/flutter_core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';

class _FakeCurrentUser implements CurrentUser {
  _FakeCurrentUser(this._snapshot) {
    _controller = StreamController<CurrentUserSnapshot?>.broadcast(sync: true);
    _controller.add(_snapshot);
  }

  CurrentUserSnapshot? _snapshot;
  late final StreamController<CurrentUserSnapshot?> _controller;

  @override
  CurrentUserSnapshot? now() => _snapshot;

  @override
  Stream<CurrentUserSnapshot?> watch() => _controller.stream;

  void emit(CurrentUserSnapshot? snapshot) {
    _snapshot = snapshot;
    _controller.add(snapshot);
  }

  Future<void> close() => _controller.close();
}

class _FakeWorkspaceRemoteDataSource
    implements WorkspaceRemoteDataSource {
  final Map<String, StreamController<List<WorkspaceModel>>> _controllers = {};
  String? lastRequestedUid;

  @override
  Stream<List<WorkspaceModel>> watchMemberships(String uid) {
    lastRequestedUid = uid;
    return _controllers
        .putIfAbsent(
          uid,
          () => StreamController<List<WorkspaceModel>>.broadcast(sync: true),
        )
        .stream;
  }

  @override
  Future<void> upsertMembership(String uid, WorkspaceModel model) async {}

  @override
  Future<void> deleteMembership(String uid, String workspaceId) async {}

  void emit(String uid, List<WorkspaceModel> models) {
    _controllers
        .putIfAbsent(
          uid,
          () => StreamController<List<WorkspaceModel>>.broadcast(sync: true),
        )
        .add(models);
  }

  Future<void> close() async {
    for (final controller in _controllers.values) {
      await controller.close();
    }
  }
}

WorkspaceModel _household(String id) => WorkspaceModel(
      id: id,
      name: 'Household $id',
      type: WorkspaceType.workspace,
      role: 'editor',
    );

void main() {
  group('WorkspaceRepositoryImpl', () {
    late _FakeCurrentUser currentUser;
    late _FakeWorkspaceRemoteDataSource remote;
    late WorkspaceRepository repository;

    setUp(() {
      currentUser =
          _FakeCurrentUser(const CurrentUserSnapshot(uid: 'uid-1', displayName: 'Alice'));
      remote = _FakeWorkspaceRemoteDataSource();
      repository = WorkspaceRepositoryImpl(remote, currentUser);
    });

    tearDown(() async {
      await currentUser.close();
      await remote.close();
    });

    test('emits personal workspace even without remote memberships', () async {
      final expectation = expectLater(
        repository.watchAll(),
        emitsThrough(predicate<List<WorkspaceEntity>>((workspaces) {
          return workspaces.length == 1 &&
              workspaces.first.isPersonal &&
              workspaces.first.name == 'Alice';
        })),
      );

      remote.emit('uid-1', const <WorkspaceModel>[]);

      await expectation;
    });

    test('prepends personal workspace before households', () async {
      final expectation = expectLater(
        repository.watchAll(),
        emitsInOrder([
          isA<List<WorkspaceEntity>>().having((list) => list.length, 'length', 1),
          predicate<List<WorkspaceEntity>>((list) {
            return list.length == 2 &&
                list.first.isPersonal &&
                !list[1].isPersonal &&
                list[1].id == 'household-1';
          }),
        ]),
      );

      remote.emit('uid-1', const <WorkspaceModel>[]);
      remote.emit('uid-1', <WorkspaceModel>[_household('household-1')]);

      await expectation;
    });

    test('listens to user changes and resubscribes', () async {
      final results = <List<WorkspaceEntity>>[];
      final subscription = repository.watchAll().listen(results.add);

      remote.emit('uid-1', <WorkspaceModel>[_household('one')]);
      await pumpEventQueue();

      currentUser.emit(
        const CurrentUserSnapshot(uid: 'uid-2', displayName: 'Bob'),
      );
      remote.emit('uid-2', <WorkspaceModel>[_household('two')]);
      await pumpEventQueue();

      await subscription.cancel();

      final personalIds = results.map((list) => list.first.id).toList();
      expect(personalIds, containsAll(['uid-1', 'uid-2']));
      expect(remote.lastRequestedUid, 'uid-2');
    });
  });
}
