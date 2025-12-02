import 'dart:async';

import 'package:expense_manager/core/workspace/current_workspace.dart';
import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_entity.dart';
import 'package:expense_manager/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:expense_manager/features/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:expense_manager/features/workspace/presentation/bloc/workspace_effect.dart';
import 'package:expense_manager/features/workspace/presentation/bloc/workspace_event.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeWorkspaceRepository implements WorkspaceRepository {
  final StreamController<List<WorkspaceEntity>> controller =
      StreamController<List<WorkspaceEntity>>.broadcast(sync: true);

  @override
  Stream<List<WorkspaceEntity>> watchAll() => controller.stream;

  void emit(List<WorkspaceEntity> workspaces) {
    controller.add(workspaces);
  }

  Future<void> close() => controller.close();
}

class _FakeCurrentWorkspace implements CurrentWorkspace {
  _FakeCurrentWorkspace() {
    _controller = StreamController<CurrentWorkspaceSnapshot?>.broadcast(sync: true);
    _controller.add(_snapshot);
  }

  CurrentWorkspaceSnapshot? _snapshot;
  late final StreamController<CurrentWorkspaceSnapshot?> _controller;

  @override
  CurrentWorkspaceSnapshot? now() => _snapshot;

  @override
  Stream<CurrentWorkspaceSnapshot?> watch() => _controller.stream;

  @override
  Future<void> select(CurrentWorkspaceSnapshot? snapshot) async {
    _snapshot = snapshot;
    _controller.add(snapshot);
  }

  Future<void> close() => _controller.close();
}

void main() {
  group('WorkspaceBloc', () {
    late _FakeWorkspaceRepository repository;
    late _FakeCurrentWorkspace currentWorkspace;
    late WorkspaceBloc bloc;
    final emittedEffects = <WorkspaceEffect>[];
    StreamSubscription<WorkspaceEffect>? effectSubscription;

    final personal = WorkspaceEntity.personal(id: 'uid-1', name: 'Alice');
    final household = WorkspaceEntity(
      id: 'household-1',
      name: 'Family',
      type: WorkspaceType.workspace,
      role: 'editor',
    );

    setUp(() {
      repository = _FakeWorkspaceRepository();
      currentWorkspace = _FakeCurrentWorkspace();
      bloc = WorkspaceBloc(repository, currentWorkspace);
      effectSubscription = bloc.effects.listen(emittedEffects.add);
    });

    tearDown(() async {
      await effectSubscription?.cancel();
      await bloc.close();
      emittedEffects.clear();
      await repository.close();
      await currentWorkspace.close();
    });

    test('selects first workspace when none active', () async {
      bloc.add(const WorkspaceStarted());
      await pumpEventQueue();

      repository.emit([personal, household]);
      await pumpEventQueue();

      expect(bloc.state.selectedWorkspaceId, personal.id);
      expect(currentWorkspace.now()!.id, personal.id);
    });

    test('dispatching selection updates current workspace', () async {
      bloc.add(const WorkspaceStarted());
      await pumpEventQueue();
      repository.emit([personal, household]);
      await pumpEventQueue();

      bloc.add(WorkspaceSelectionRequested(household.id));
      await pumpEventQueue();

      expect(bloc.state.selectedWorkspaceId, household.id);
      expect(currentWorkspace.now()!.id, household.id);
    });

    test('reacts to active workspace changes from controller', () async {
      bloc.add(const WorkspaceStarted());
      await pumpEventQueue();
      repository.emit([personal, household]);
      await pumpEventQueue();

      await currentWorkspace.select(
        CurrentWorkspaceSnapshot(
          id: household.id,
          type: WorkspaceType.workspace,
          name: household.name,
          role: household.role,
        ),
      );
      await pumpEventQueue();

      expect(bloc.state.selectedWorkspaceId, household.id);
    });

    test('emits effect when selected household is removed', () async {
      bloc.add(const WorkspaceStarted());
      await pumpEventQueue();
      repository.emit([personal, household]);
      await pumpEventQueue();

      bloc.add(WorkspaceSelectionRequested(household.id));
      await pumpEventQueue();
      emittedEffects.clear();

      repository.emit([personal]);
      await pumpEventQueue();

      expect(
        emittedEffects.whereType<WorkspaceShowLostAccessEffect>().length,
        1,
      );
      final effect = emittedEffects.whereType<WorkspaceShowLostAccessEffect>().single;
      expect(effect.workspaceId, household.id);
      expect(effect.workspaceName, household.name);
    });
  });
}
