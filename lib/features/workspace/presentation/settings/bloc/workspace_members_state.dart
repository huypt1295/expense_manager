import 'package:expense_manager/features/workspace/domain/entities/workspace_invitation_entity.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_member_entity.dart';
import 'package:flutter_core/flutter_core.dart';

class WorkspaceMembersState extends BaseBlocState with EquatableMixin {
  const WorkspaceMembersState({
    this.workspaceId = '',
    this.workspaceName = '',
    this.currentUserId = '',
    this.currentUserRole = 'viewer',
    this.members = const <WorkspaceMemberEntity>[],
    this.invitations = const <WorkspaceInvitationEntity>[],
    this.isLoading = true,
    this.errorMessage,
  });

  final String workspaceId;
  final String workspaceName;
  final String currentUserId;
  final String currentUserRole;
  final List<WorkspaceMemberEntity> members;
  final List<WorkspaceInvitationEntity> invitations;
  final bool isLoading;
  final String? errorMessage;

  bool get isOwner => currentUserRole.toLowerCase() == 'owner';
  bool get isEditor => currentUserRole.toLowerCase() == 'editor';

  WorkspaceMembersState copyWith({
    String? workspaceId,
    String? workspaceName,
    String? currentUserId,
    String? currentUserRole,
    List<WorkspaceMemberEntity>? members,
    List<WorkspaceInvitationEntity>? invitations,
    bool? isLoading,
    bool clearError = false,
    String? errorMessage,
  }) {
    return WorkspaceMembersState(
      workspaceId: workspaceId ?? this.workspaceId,
      workspaceName: workspaceName ?? this.workspaceName,
      currentUserId: currentUserId ?? this.currentUserId,
      currentUserRole: currentUserRole ?? this.currentUserRole,
      members: members ?? this.members,
      invitations: invitations ?? this.invitations,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => <Object?>[
        workspaceId,
        workspaceName,
        currentUserId,
        currentUserRole,
        members,
        invitations,
        isLoading,
        errorMessage,
      ];
}

