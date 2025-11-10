import 'package:expense_manager/features/workspace/domain/entities/household_invitation_entity.dart';
import 'package:expense_manager/features/workspace/domain/entities/household_member_entity.dart';
import 'package:flutter_core/flutter_core.dart';

class WorkspaceMembersState extends BaseBlocState with EquatableMixin {
  const WorkspaceMembersState({
    this.householdId = '',
    this.householdName = '',
    this.currentUserId = '',
    this.currentUserRole = 'viewer',
    this.members = const <WorkspaceMemberEntity>[],
    this.invitations = const <HouseholdInvitationEntity>[],
    this.isLoading = true,
    this.errorMessage,
  });

  final String householdId;
  final String householdName;
  final String currentUserId;
  final String currentUserRole;
  final List<WorkspaceMemberEntity> members;
  final List<HouseholdInvitationEntity> invitations;
  final bool isLoading;
  final String? errorMessage;

  bool get isOwner => currentUserRole.toLowerCase() == 'owner';
  bool get isEditor => currentUserRole.toLowerCase() == 'editor';

  WorkspaceMembersState copyWith({
    String? householdId,
    String? householdName,
    String? currentUserId,
    String? currentUserRole,
    List<WorkspaceMemberEntity>? members,
    List<HouseholdInvitationEntity>? invitations,
    bool? isLoading,
    bool clearError = false,
    String? errorMessage,
  }) {
    return WorkspaceMembersState(
      householdId: householdId ?? this.householdId,
      householdName: householdName ?? this.householdName,
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
        householdId,
        householdName,
        currentUserId,
        currentUserRole,
        members,
        invitations,
        isLoading,
        errorMessage,
      ];
}

