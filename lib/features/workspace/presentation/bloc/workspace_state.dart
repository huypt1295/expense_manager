import 'package:expense_manager/features/workspace/domain/entities/workspace_entity.dart';
import 'package:flutter_core/flutter_core.dart';

class WorkspaceState extends BaseBlocState with EquatableMixin {
  const WorkspaceState({
    this.workspaces = const <WorkspaceEntity>[],
    this.selectedWorkspaceId,
    this.isLoading = false,
    this.errorMessage,
  });

  final List<WorkspaceEntity> workspaces;
  final String? selectedWorkspaceId;
  final bool isLoading;
  final String? errorMessage;

  WorkspaceState copyWith({
    List<WorkspaceEntity>? workspaces,
    String? selectedWorkspaceId,
    bool? isLoading,
    bool clearError = false,
    String? errorMessage,
  }) {
    return WorkspaceState(
      workspaces: workspaces ?? this.workspaces,
      selectedWorkspaceId: selectedWorkspaceId ?? this.selectedWorkspaceId,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => <Object?>[
        workspaces,
        selectedWorkspaceId,
        isLoading,
        errorMessage,
      ];
}
