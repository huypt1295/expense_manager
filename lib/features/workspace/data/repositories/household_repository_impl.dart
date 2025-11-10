import 'dart:async';

import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:expense_manager/features/workspace/data/datasources/household_remote_data_source.dart';
import 'package:expense_manager/features/workspace/data/datasources/workspace_remote_data_source.dart';
import 'package:expense_manager/features/workspace/data/models/household_invitation_model.dart';
import 'package:expense_manager/features/workspace/data/models/household_member_model.dart';
import 'package:expense_manager/features/workspace/data/models/household_model.dart';
import 'package:expense_manager/features/workspace/data/models/workspace_model.dart';
import 'package:expense_manager/features/workspace/domain/entities/household_entity.dart';
import 'package:expense_manager/features/workspace/domain/entities/household_invitation_entity.dart';
import 'package:expense_manager/features/workspace/domain/entities/household_member_entity.dart';
import 'package:expense_manager/features/workspace/domain/repositories/household_repository.dart';
import 'package:flutter_core/flutter_core.dart';

@LazySingleton(as: HouseholdRepository)
class HouseholdRepositoryImpl implements HouseholdRepository {
  HouseholdRepositoryImpl(
    this._householdRemote,
    this._workspaceRemote,
    this._currentUser,
  );

  final HouseholdRemoteDataSource _householdRemote;
  final WorkspaceRemoteDataSource _workspaceRemote;
  final CurrentUser _currentUser;

  @override
  Future<HouseholdEntity> createHousehold({
    required String name,
    required String currencyCode,
    required List<String> inviteEmails,
  }) async {
    final snapshot = _currentUser.now();
    final uid = snapshot?.uid;
    if (uid == null || uid.isEmpty) {
      throw AuthException('auth.required', tokenExpired: true);
    }

    final ownerName = snapshot?.displayName?.trim();
    final ownerEmail = snapshot?.email ?? '';
    final normalizedName = (name.trim().isEmpty ? 'Household' : name.trim());
    final now = DateTime.now();

    final householdId = await _householdRemote.createHousehold(
      HouseholdModel(
        id: '',
        name: normalizedName,
        currencyCode: currencyCode,
        ownerId: uid,
        createdAt: now,
        updatedAt: now,
      ),
    );

    await _workspaceRemote.upsertMembership(
      uid,
      WorkspaceModel(
        id: householdId,
        name: normalizedName,
        type: WorkspaceType.household,
        role: 'owner',
      ),
    );

    await _householdRemote.upsertMember(
      householdId,
      HouseholdMemberModel(
        userId: uid,
        displayName: ownerName?.isNotEmpty == true ? ownerName! : ownerEmail,
        email: ownerEmail,
        role: 'owner',
        status: HouseholdMemberStatus.active,
        joinedAt: now,
      ),
    );

    final uniqueInvites = inviteEmails
        .map((email) => email.trim().toLowerCase())
        .where((email) => email.isNotEmpty && email != ownerEmail.toLowerCase())
        .toSet();

    for (final email in uniqueInvites) {
      await _householdRemote.createInvitation(
        householdId,
        HouseholdInvitationModel(
          id: '',
          email: email,
          role: 'viewer',
          invitedBy: uid,
          status: HouseholdInvitationStatus.pending,
          createdAt: now,
        ),
      );
    }

    return HouseholdEntity(
      id: householdId,
      name: normalizedName,
      currencyCode: currencyCode,
      ownerId: uid,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Stream<List<WorkspaceMemberEntity>> watchMembers(String householdId) {
    return _householdRemote
        .watchMembers(householdId)
        .map((models) => models.map((model) => model.toEntity()).toList());
  }

  @override
  Stream<List<HouseholdInvitationEntity>> watchInvitations(String householdId) {
    return _householdRemote
        .watchInvitations(householdId)
        .map((models) => models.map((model) => model.toEntity()).toList());
  }

  @override
  Future<void> updateMemberRole({
    required String householdId,
    required String memberId,
    required String role,
  }) {
    return _householdRemote.updateMemberRole(householdId, memberId, role);
  }

  @override
  Future<void> removeMember({
    required String householdId,
    required String memberId,
  }) async {
    await _householdRemote.deleteMember(householdId, memberId);
    await _workspaceRemote.deleteMembership(memberId, householdId);
  }

  @override
  Future<void> sendInvitation({
    required String householdId,
    required String email,
    required String role,
  }) async {
    final snapshot = _currentUser.now();
    final uid = snapshot?.uid;
    if (uid == null || uid.isEmpty) {
      throw AuthException('auth.required', tokenExpired: true);
    }
    final now = DateTime.now();
    await _householdRemote.createInvitation(
      householdId,
      HouseholdInvitationModel(
        id: '',
        email: email.trim().toLowerCase(),
        role: role,
        invitedBy: uid,
        status: HouseholdInvitationStatus.pending,
        createdAt: now,
      ),
    );
  }

  @override
  Future<void> cancelInvitation({
    required String householdId,
    required String invitationId,
  }) {
    return _householdRemote.deleteInvitation(householdId, invitationId);
  }

  @override
  Future<void> ensurePersonalWorkspace() async {
    final snapshot = _currentUser.now();
    final uid = snapshot?.uid;
    if (uid == null || uid.isEmpty) {
      return;
    }

    final displayName = snapshot?.displayName?.trim();
    final name = (displayName != null && displayName.isNotEmpty)
        ? displayName
        : 'Personal';

    await _workspaceRemote.upsertMembership(
      uid,
      WorkspaceModel.personal(id: uid, name: name),
    );
  }
}
