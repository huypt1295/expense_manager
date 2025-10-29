import 'dart:async';

import 'package:expense_manager/core/workspace/current_workspace.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_entity.dart';
import 'package:expense_manager/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:flutter_core/flutter_core.dart';

import 'workspace_effect.dart';
import 'workspace_event.dart';
import 'workspace_state.dart';

@injectable
class WorkspaceBloc
    extends BaseBloc<WorkspaceEvent, WorkspaceState, WorkspaceEffect> {
  WorkspaceBloc(
    this._repository,
    this._currentWorkspace, {
    Logger? logger,
  }) : super(const WorkspaceState(isLoading: true), logger: logger) {
    on<WorkspaceStarted>(_onStarted);
    on<WorkspaceSelectionRequested>(_onSelectionRequested);
    on<WorkspaceWorkspacesUpdated>(_onWorkspacesUpdated);
    on<WorkspaceWorkspacesFailed>(_onWorkspacesFailed);
    on<WorkspaceActiveChanged>(_onActiveChanged);
  }

  final WorkspaceRepository _repository;
  final CurrentWorkspace _currentWorkspace;

  StreamSubscription<List<WorkspaceEntity>>? _workspacesSubscription;
  StreamSubscription<CurrentWorkspaceSnapshot?>? _activeSubscription;

  Future<void> _onStarted(
    WorkspaceStarted event,
    Emitter<WorkspaceState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    _workspacesSubscription ??=
        _repository.watchAll().listen((workspaces) {
      add(WorkspaceWorkspacesUpdated(workspaces));
    }, onError: (Object error, StackTrace stackTrace) {
      add(WorkspaceWorkspacesFailed(error.toString()));
    });

    _activeSubscription ??=
        _currentWorkspace.watch().listen((snapshot) {
      add(WorkspaceActiveChanged(snapshot));
    });
  }

  Future<void> _onSelectionRequested(
    WorkspaceSelectionRequested event,
    Emitter<WorkspaceState> emit,
  ) async {
    final selected = _findWorkspace(state.workspaces, event.workspaceId);
    if (selected == null) {
      return;
    }
    await _currentWorkspace.select(_toSnapshot(selected));
    emit(state.copyWith(selectedWorkspaceId: selected.id, clearError: true));
  }

  void _onWorkspacesUpdated(
    WorkspaceWorkspacesUpdated event,
    Emitter<WorkspaceState> emit,
  ) {
    final activeId = _currentWorkspace.now()?.id ?? state.selectedWorkspaceId;
    final resolvedId = _resolveSelection(activeId, event.workspaces);
    emit(
      state.copyWith(
        workspaces: event.workspaces,
        selectedWorkspaceId: resolvedId,
        isLoading: false,
        clearError: true,
      ),
    );

    if (resolvedId == null) {
      return;
    }

    if (activeId != resolvedId) {
      final resolved = _findWorkspace(event.workspaces, resolvedId);
      if (resolved != null) {
        unawaited(_currentWorkspace.select(_toSnapshot(resolved)));
      }
    }
  }

  void _onWorkspacesFailed(
    WorkspaceWorkspacesFailed event,
    Emitter<WorkspaceState> emit,
  ) {
    emit(state.copyWith(isLoading: false, errorMessage: event.message));
    emitEffect(WorkspaceShowErrorEffect(event.message));
  }

  void _onActiveChanged(
    WorkspaceActiveChanged event,
    Emitter<WorkspaceState> emit,
  ) {
    final snapshot = event.snapshot;
    if (snapshot == null) {
      emit(state.copyWith(selectedWorkspaceId: null));
      return;
    }

    if (snapshot.id == state.selectedWorkspaceId) {
      return;
    }

    if (!state.workspaces.any((workspace) => workspace.id == snapshot.id)) {
      return;
    }

    emit(state.copyWith(selectedWorkspaceId: snapshot.id, clearError: true));
  }

  String? _resolveSelection(
    String? activeId,
    List<WorkspaceEntity> workspaces,
  ) {
    if (workspaces.isEmpty) {
      return null;
    }
    if (activeId != null &&
        workspaces.any((workspace) => workspace.id == activeId)) {
      return activeId;
    }
    return workspaces.first.id;
  }

  CurrentWorkspaceSnapshot _toSnapshot(WorkspaceEntity entity) {
    return CurrentWorkspaceSnapshot(
      id: entity.id,
      type: entity.type,
      name: entity.name,
      role: entity.role,
    );
  }

  WorkspaceEntity? _findWorkspace(
    List<WorkspaceEntity> workspaces,
    String id,
  ) {
    for (final workspace in workspaces) {
      if (workspace.id == id) {
        return workspace;
      }
    }
    return null;
  }

  @override
  Future<void> close() async {
    await _workspacesSubscription?.cancel();
    await _activeSubscription?.cancel();
    return super.close();
  }
}
