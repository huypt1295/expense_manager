import 'package:expense_manager/features/workspace/domain/entities/workspace_detail_entity.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_invitation_entity.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_member_entity.dart';

abstract interface class WorkspaceDetailRepository {
  Future<WorkspaceDetailEntity> createWorkspace({
    required String name,
    required String currencyCode,
    required List<String> inviteEmails,
  });

  Stream<List<WorkspaceMemberEntity>> watchMembers(String workspaceId);

  Stream<List<WorkspaceInvitationEntity>> watchInvitations(String workspaceId);

  Future<void> updateMemberRole({
    required String workspaceId,
    required String memberId,
    required String role,
  });

  Future<void> removeMember({
    required String workspaceId,
    required String memberId,
  });

  Future<void> deleteWorkspace({
    required String userId,
    required String workspaceId,
  });

  Future<void> sendInvitation({
    required String workspaceId,
    required String email,
    required String role,
  });

  Future<void> cancelInvitation({
    required String workspaceId,
    required String invitationId,
  });

  Future<void> ensurePersonalWorkspace();

  /// Verifies that member document exists for the given workspace and user
  /// Returns true if member exists, false otherwise
  Future<bool> verifyMemberExists({
    required String workspaceId,
    required String userId,
  });
}
