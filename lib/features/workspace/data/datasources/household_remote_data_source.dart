import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show FieldValue;
import 'package:expense_manager/features/workspace/data/models/household_invitation_model.dart';
import 'package:expense_manager/features/workspace/data/models/household_member_model.dart';
import 'package:expense_manager/features/workspace/data/models/household_model.dart';
import 'package:flutter_core/flutter_core.dart';

@lazySingleton
class HouseholdRemoteDataSource {
  HouseholdRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _households =>
      _firestore.collection('households');

  Future<String> createHousehold(HouseholdModel model) async {
    final doc = _households.doc();
    await doc.set(model.toFirestore());
    return doc.id;
  }

  Future<void> updateHousehold(String id, HouseholdModel model) {
    return _households.doc(id).set(
          model.toFirestore(),
          SetOptions(merge: true),
        );
  }

  CollectionReference<Map<String, dynamic>> _members(String householdId) {
    return _households.doc(householdId).collection('members');
  }

  CollectionReference<Map<String, dynamic>> _invitations(String householdId) {
    return _households.doc(householdId).collection('invitations');
  }

  Future<void> upsertMember(
    String householdId,
    HouseholdMemberModel model,
  ) {
    return _members(householdId)
        .doc(model.userId)
        .set(model.toFirestore(), SetOptions(merge: true));
  }

  Future<void> deleteMember(String householdId, String userId) {
    return _members(householdId).doc(userId).delete();
  }

  Future<void> updateMemberRole(
    String householdId,
    String userId,
    String role,
  ) {
    return _members(householdId).doc(userId).set(
      <String, dynamic>{
        'role': role,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Stream<List<HouseholdMemberModel>> watchMembers(String householdId) {
    return _members(householdId).orderBy('joinedAt').snapshots().map(
          (snapshot) => snapshot.docs
              .map(HouseholdMemberModel.fromFirestore)
              .toList(growable: false),
        );
  }

  Future<String> createInvitation(
    String householdId,
    HouseholdInvitationModel model,
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
    return _invitations(householdId).doc(invitationId).set(
      <String, dynamic>{
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Stream<List<HouseholdInvitationModel>> watchInvitations(
    String householdId,
  ) {
    return _invitations(householdId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(HouseholdInvitationModel.fromFirestore)
              .toList(growable: false),
        );
  }
}
