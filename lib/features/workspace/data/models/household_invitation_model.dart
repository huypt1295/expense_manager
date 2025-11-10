import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/features/workspace/domain/entities/household_invitation_entity.dart';

class HouseholdInvitationModel {
  const HouseholdInvitationModel({
    required this.id,
    required this.email,
    required this.role,
    required this.invitedBy,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String email;
  final String role;
  final String invitedBy;
  final HouseholdInvitationStatus status;
  final DateTime createdAt;

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'email': email,
      'role': role,
      'invitedBy': invitedBy,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  HouseholdInvitationEntity toEntity() {
    return HouseholdInvitationEntity(
      id: id,
      email: email,
      role: role,
      invitedBy: invitedBy,
      status: status,
      createdAt: createdAt,
    );
  }

  static HouseholdInvitationModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? const <String, dynamic>{};
    return HouseholdInvitationModel(
      id: snapshot.id,
      email: (data['email'] as String?) ?? '',
      role: (data['role'] as String?) ?? 'viewer',
      invitedBy: (data['invitedBy'] as String?) ?? '',
      status: _parseStatus(data['status']),
      createdAt: _parseTimestamp(data['createdAt']),
    );
  }

  static HouseholdInvitationStatus _parseStatus(dynamic raw) {
    final value = (raw as String?)?.toLowerCase();
    switch (value) {
      case 'accepted':
        return HouseholdInvitationStatus.accepted;
      case 'revoked':
        return HouseholdInvitationStatus.revoked;
      case 'expired':
        return HouseholdInvitationStatus.expired;
      case 'pending':
      default:
        return HouseholdInvitationStatus.pending;
    }
  }

  static DateTime _parseTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return DateTime.now();
  }
}
