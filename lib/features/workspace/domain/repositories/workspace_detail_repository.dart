import 'package:expense_manager/features/workspace/domain/entities/workspace_detail_entity.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_invitation_entity.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_member_entity.dart';

abstract interface class WorkspaceDetailRepository {
  Future<WorkspaceDetailEntity> createHousehold({
    required String name,
    required String currencyCode,
    required List<String> inviteEmails,
  });

  Stream<List<WorkspaceMemberEntity>> watchMembers(String householdId);

  Stream<List<WorkspaceInvitationEntity>> watchInvitations(String householdId);

  Future<void> updateMemberRole({
    required String householdId,
    required String memberId,
    required String role,
  });

  Future<void> removeMember({
    required String householdId,
    required String memberId,
  });

  Future<void> deleteWorkspace({
    required String userId,
    required String workspaceId,
  });

  Future<void> sendInvitation({
    required String householdId,
    required String email,
    required String role,
  });

  Future<void> cancelInvitation({
    required String householdId,
    required String invitationId,
  });


  Future<void> ensurePersonalWorkspace();
}
