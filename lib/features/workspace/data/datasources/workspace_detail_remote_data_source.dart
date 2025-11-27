import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/features/workspace/data/models/workspace_invitation_model.dart';
import 'package:expense_manager/features/workspace/data/models/workspace_member_model.dart';
import 'package:expense_manager/features/workspace/data/models/workspace_detail_model.dart';
import 'package:flutter_core/flutter_core.dart';

@lazySingleton
class WorkspaceDetailRemoteDataSource {
  WorkspaceDetailRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _workspaces =>
      _firestore.collection('workspaces');

  CollectionReference<Map<String, dynamic>> _members(String workspaceId) {
    return _workspaces.doc(workspaceId).collection('members');
  }

  CollectionReference<Map<String, dynamic>> _invitations(String workspaceId) {
    return _workspaces.doc(workspaceId).collection('invitations');
  }

  Future<String> createWorkspace(WorkspaceDetailModel model) async {
    // Use model.id if provided (for personal workspace), otherwise generate new ID
    final doc = model.id.isNotEmpty
        ? _workspaces.doc(model.id)
        : _workspaces.doc();
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

  Future<void> deleteAllMembers(String workspaceId) async {
    final snapshot = await _members(workspaceId).get();
    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  Future<void> deleteWorkspace(String workspaceId, String userId) async {
    final snapshot = await _members(workspaceId).doc(userId).get();
    if (!snapshot.exists) return;
    final member = WorkspaceMemberModel.fromFirestore(snapshot);
    if (member.role != 'owner') return;

    return _workspaces.doc(workspaceId).delete();
  }

  Future<void> updateWorkspace(String id, WorkspaceDetailModel model) {
    return _workspaces
        .doc(id)
        .set(model.toFirestore(), SetOptions(merge: true));
  }

  Future<void> upsertMember(String workspaceId, WorkspaceMemberModel model) {
    return _members(
      workspaceId,
    ).doc(model.userId).set(model.toFirestore(), SetOptions(merge: true));
  }

  Future<void> deleteMember(String workspaceId, String userId) {
    return _members(workspaceId).doc(userId).delete();
  }

  Future<void> updateMemberRole(
    String workspaceId,
    String userId,
    String role,
  ) {
    return _members(workspaceId).doc(userId).set(<String, dynamic>{
      'role': role,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<List<WorkspaceMemberModel>> watchMembers(String workspaceId) {
    return _members(workspaceId)
        .orderBy('joinedAt')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(WorkspaceMemberModel.fromFirestore)
              .toList(growable: false),
        );
  }

  Future<String> createInvitation(
    String workspaceId,
    WorkspaceInvitationModel model,
  ) async {
    final doc = _invitations(workspaceId).doc();
    await doc.set(model.toFirestore());
    return doc.id;
  }

  Future<void> deleteInvitation(String workspaceId, String invitationId) {
    return _invitations(workspaceId).doc(invitationId).delete();
  }

  Future<void> updateInvitationStatus(
    String workspaceId,
    String invitationId,
    String status,
  ) {
    return _invitations(workspaceId).doc(invitationId).set(<String, dynamic>{
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<List<WorkspaceInvitationModel>> watchInvitations(String workspaceId) {
    return _invitations(workspaceId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(WorkspaceInvitationModel.fromFirestore)
              .toList(growable: false),
        );
  }
}
