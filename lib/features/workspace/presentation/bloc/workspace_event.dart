import 'package:expense_manager/core/workspace/current_workspace.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_entity.dart';
import 'package:flutter_core/flutter_core.dart';

abstract class WorkspaceEvent extends BaseBlocEvent {
  const WorkspaceEvent();
}

class WorkspaceStarted extends WorkspaceEvent {
  const WorkspaceStarted();
}

class WorkspaceSelectionRequested extends WorkspaceEvent {
  const WorkspaceSelectionRequested(this.workspaceId);

  final String workspaceId;
}

class WorkspaceWorkspacesUpdated extends WorkspaceEvent {
  const WorkspaceWorkspacesUpdated(this.workspaces);

  final List<WorkspaceEntity> workspaces;
}

class WorkspaceWorkspacesFailed extends WorkspaceEvent {
  const WorkspaceWorkspacesFailed(this.message);

  final String message;
}

class WorkspaceActiveChanged extends WorkspaceEvent {
  const WorkspaceActiveChanged(this.snapshot);

  final CurrentWorkspaceSnapshot? snapshot;
}
