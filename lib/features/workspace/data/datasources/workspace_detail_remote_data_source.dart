import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/features/workspace/data/models/workspace_invitation_model.dart';
import 'package:expense_manager/features/workspace/data/models/workspace_member_model.dart';
import 'package:expense_manager/features/workspace/data/models/workspace_detail_model.dart';
import 'package:flutter_core/flutter_core.dart';

@lazySingleton
class WorkspaceDetailRemoteDataSource {
  WorkspaceDetailRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _households =>
      _firestore.collection('workspaces');

  CollectionReference<Map<String, dynamic>> _members(String householdId) {
    return _households.doc(householdId).collection('members');
  }

  CollectionReference<Map<String, dynamic>> _invitations(String householdId) {
    return _households.doc(householdId).collection('invitations');
  }

  Future<String> createHousehold(WorkspaceDetailModel model) async {
    final doc = _households.doc();
    await doc.set(model.toFirestore());
    return doc.id;
  }

  Future<WorkspaceMemberModel?> getMember(
    String workspaceId,
    String userId,
  ) async {
    final doc = await _members(workspaceId).doc(userId).get();
    if (!doc.exists) return null;
    return WorkspaceMemberModel.fromFirestore(doc);
  }

  Future<List<WorkspaceMemberModel>> getAllMembers(String workspaceId) async {
    final snapshot = await _members(workspaceId).get();
    return snapshot.docs
        .map(WorkspaceMemberModel.fromDoc)
        .toList(growable: false);
  }

  // Trong HouseholdRemote
  Future<void> deleteAllMembers(String workspaceId) async {
    final snapshot = await _members(workspaceId).get();
    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  Future<void> deleteHousehold(String householdId, String userId) async {
    final snapshot = await _members(householdId).doc(userId).get();
    if (!snapshot.exists) return;
    final member = WorkspaceMemberModel.fromFirestore(snapshot);
    if (member.role != 'owner') return;

    return _households.doc(householdId).delete();
  }

  Future<void> updateHousehold(String id, WorkspaceDetailModel model) {
    return _households
        .doc(id)
        .set(model.toFirestore(), SetOptions(merge: true));
  }

  Future<void> upsertMember(String householdId, WorkspaceMemberModel model) {
    return _members(
      householdId,
    ).doc(model.userId).set(model.toFirestore(), SetOptions(merge: true));
  }

  Future<void> deleteMember(String householdId, String userId) {
    return _members(householdId).doc(userId).delete();
  }

  Future<void> updateMemberRole(
    String householdId,
    String userId,
    String role,
  ) {
    return _members(householdId).doc(userId).set(<String, dynamic>{
      'role': role,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<List<WorkspaceMemberModel>> watchMembers(String householdId) {
    return _members(householdId)
        .orderBy('joinedAt')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(WorkspaceMemberModel.fromFirestore)
              .toList(growable: false),
        );
  }

  Future<String> createInvitation(
    String householdId,
    WorkspaceInvitationModel model,
  ) async {
    final doc = _invitations(householdId).doc();
    await doc.set(model.toFirestore());
    return doc.id;
  }

  Future<void> deleteInvitation(String householdId, String invitationId) {
    return _invitations(householdId).doc(invitationId).delete();
  }

  Future<void> updateInvitationStatus(
    String householdId,
    String invitationId,
    String status,
  ) {
    return _invitations(householdId).doc(invitationId).set(<String, dynamic>{
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<List<WorkspaceInvitationModel>> watchInvitations(String householdId) {
    return _invitations(householdId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(WorkspaceInvitationModel.fromFirestore)
              .toList(growable: false),
        );
  }
}
