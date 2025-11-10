import 'package:expense_manager/features/workspace/domain/entities/household_entity.dart';
import 'package:expense_manager/features/workspace/domain/entities/household_invitation_entity.dart';
import 'package:expense_manager/features/workspace/domain/entities/household_member_entity.dart';

abstract interface class HouseholdRepository {
  Future<HouseholdEntity> createHousehold({
    required String name,
    required String currencyCode,
    required List<String> inviteEmails,
  });

  Stream<List<WorkspaceMemberEntity>> watchMembers(String householdId);

  Stream<List<HouseholdInvitationEntity>> watchInvitations(String householdId);

  Future<void> updateMemberRole({
    required String householdId,
    required String memberId,
    required String role,
  });

  Future<void> removeMember({
    required String householdId,
    required String memberId,
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
