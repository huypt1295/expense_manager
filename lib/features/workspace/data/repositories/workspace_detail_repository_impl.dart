import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:expense_manager/features/workspace/data/datasources/workspace_detail_remote_data_source.dart';
import 'package:expense_manager/features/workspace/data/datasources/workspace_remote_data_source.dart';
import 'package:expense_manager/features/workspace/data/models/workspace_invitation_model.dart';
import 'package:expense_manager/features/workspace/data/models/workspace_member_model.dart';
import 'package:expense_manager/features/workspace/data/models/workspace_detail_model.dart';
import 'package:expense_manager/features/workspace/data/models/workspace_model.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_detail_entity.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_invitation_entity.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_member_entity.dart';
import 'package:expense_manager/features/workspace/domain/repositories/workspace_detail_repository.dart';
import 'package:flutter_core/flutter_core.dart';

@LazySingleton(as: WorkspaceDetailRepository)
class WorkspaceDetailRepositoryImpl implements WorkspaceDetailRepository {
  WorkspaceDetailRepositoryImpl(
    this._firestore,
    this._householdRemote,
    this._workspaceRemote,
    this._currentUser,
  );

  final FirebaseFirestore _firestore;
  final WorkspaceDetailRemoteDataSource _householdRemote;
  final WorkspaceRemoteDataSource _workspaceRemote;
  final CurrentUser _currentUser;

  @override
  Future<WorkspaceDetailEntity> createHousehold({
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
      WorkspaceDetailModel(
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
      WorkspaceMemberModel(
        userId: uid,
        displayName: ownerName?.isNotEmpty == true ? ownerName! : ownerEmail,
        email: ownerEmail,
        role: 'owner',
        status: WorkspaceMemberStatus.active,
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
        WorkspaceInvitationModel(
          id: '',
          email: email,
          role: 'viewer',
          invitedBy: uid,
          status: WorkspaceInvitationStatus.pending,
          createdAt: now,
        ),
      );
    }

    return WorkspaceDetailEntity(
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
  Stream<List<WorkspaceInvitationEntity>> watchInvitations(String householdId) {
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
  Future<void> deleteWorkspace({
    required String userId,
    required String workspaceId,
  }) async {
    // 1. Verify owner
    final ownerMember = await _householdRemote.getMember(workspaceId, userId);
    if (ownerMember == null || ownerMember.role != 'owner') {
      throw Exception('Chỉ owner mới có quyền xóa workspace');
    }

    // 2. *** LẤY MEMBERS NGAY LẬP TỨC - KHI CHƯA XÓA GÌ CẢ ***
    final members = await _householdRemote.getAllMembers(workspaceId);

    // 3. Batch delete tất cả
    final batch = _firestore.batch();

    // 3.1. Xóa user memberships
    for (final member in members) {
      final ref = _firestore
          .collection('users')
          .doc(member.userId)
          .collection('workspaces')
          .doc(workspaceId);
      batch.delete(ref);
    }

    // 3.2. Xóa members subcollection
    for (final member in members) {
      final ref = _firestore
          .collection('households')
          .doc(workspaceId)
          .collection('members')
          .doc(member.userId);
      batch.delete(ref);
    }

    // 3.3. Xóa household document
    final householdRef = _firestore.collection('households').doc(workspaceId);
    batch.delete(householdRef);

    // 4. Commit batch một lần
    await batch.commit();
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
      WorkspaceInvitationModel(
        id: '',
        email: email.trim().toLowerCase(),
        role: role,
        invitedBy: uid,
        status: WorkspaceInvitationStatus.pending,
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
    final email = snapshot?.email ?? '';
    final name = (displayName != null && displayName.isNotEmpty)
        ? displayName
        : 'Personal';

    // 1. Create/update personal workspace document
    final now = DateTime.now();
    final workspaceDoc = await _firestore.collection('workspaces').doc(uid).get();
    
    if (!workspaceDoc.exists) {
      await _householdRemote.createHousehold(
        WorkspaceDetailModel(
          id: uid,
          name: name,
          currencyCode: 'VND',
          ownerId: uid,
          type: WorkspaceType.personal,
          createdAt: now,
          updatedAt: now,
        ),
      );

      // 2. Create member entry for personal workspace
      await _householdRemote.upsertMember(
        uid,
        WorkspaceMemberModel(
          userId: uid,
          displayName: displayName ?? email,
          email: email,
          role: 'owner',
          status: WorkspaceMemberStatus.active,
          joinedAt: now,
        ),
      );
    }

    // 3. Ensure denormalized membership exists
    await _workspaceRemote.upsertMembership(
      uid,
      WorkspaceModel.personal(id: uid, name: name),
    );
  }
}
