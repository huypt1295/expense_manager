import 'package:expense_manager/features/workspace/domain/entities/household_invitation_entity.dart';
import 'package:expense_manager/features/workspace/domain/entities/household_member_entity.dart';
import 'package:flutter_core/flutter_core.dart';

abstract class WorkspaceMembersEvent extends BaseBlocEvent with EquatableMixin {
  const WorkspaceMembersEvent();

  @override
  List<Object?> get props => const [];
}

class WorkspaceMembersStarted extends WorkspaceMembersEvent {
  const WorkspaceMembersStarted({
    required this.householdId,
    required this.householdName,
    required this.currentUserId,
    required this.currentUserRole,
  });

  final String householdId;
  final String householdName;
  final String currentUserId;
  final String currentUserRole;

  @override
  List<Object?> get props =>
      <Object?>[householdId, householdName, currentUserId, currentUserRole];
}

class WorkspaceMembersRoleChanged extends WorkspaceMembersEvent {
  const WorkspaceMembersRoleChanged({
    required this.memberId,
    required this.role,
  });

  final String memberId;
  final String role;

  @override
  List<Object?> get props => <Object?>[memberId, role];
}

class WorkspaceMembersRemoved extends WorkspaceMembersEvent {
  const WorkspaceMembersRemoved(this.memberId);

  final String memberId;

  @override
  List<Object?> get props => <Object?>[memberId];
}

class WorkspaceMembersInvitationSent extends WorkspaceMembersEvent {
  const WorkspaceMembersInvitationSent(this.email, {this.role = 'viewer'});

  final String email;
  final String role;

  @override
  List<Object?> get props => <Object?>[email, role];
}

class WorkspaceMembersInvitationCancelled extends WorkspaceMembersEvent {
  const WorkspaceMembersInvitationCancelled(this.invitationId);

  final String invitationId;

  @override
  List<Object?> get props => <Object?>[invitationId];
}

class WorkspaceMembersDataUpdated extends WorkspaceMembersEvent {
  const WorkspaceMembersDataUpdated({
    required this.members,
    required this.invitations,
  });

  final List<WorkspaceMemberEntity> members;
  final List<HouseholdInvitationEntity> invitations;

  @override
  List<Object?> get props => <Object?>[members, invitations];
}

class WorkspaceMembersErrorOccurred extends WorkspaceMembersEvent {
  const WorkspaceMembersErrorOccurred(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

