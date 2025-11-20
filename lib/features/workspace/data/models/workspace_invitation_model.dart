import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_invitation_entity.dart';

class WorkspaceInvitationModel {
  const WorkspaceInvitationModel({
    required this.id,
    required this.email,
    required this.role,
    required this.invitedBy,
    required this.status,
    required this.createdAt,
    this.expiresAt,
    this.invitedUsername,
  });

  final String id;
  final String email;
  final String role;
  final String invitedBy;
  final WorkspaceInvitationStatus status;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String? invitedUsername;

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'email': email,
      'role': role,
      'invitedBy': invitedBy,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      if (expiresAt != null) 'expiresAt': Timestamp.fromDate(expiresAt!),
      if (invitedUsername != null) 'invitedUsername': invitedUsername,
    };
  }

  WorkspaceInvitationEntity toEntity() {
    return WorkspaceInvitationEntity(
      id: id,
      email: email,
      role: role,
      invitedBy: invitedBy,
      status: status,
      createdAt: createdAt,
      expiresAt: expiresAt,
      invitedUsername: invitedUsername,
    );
  }

  static WorkspaceInvitationModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? const <String, dynamic>{};
    return WorkspaceInvitationModel(
      id: snapshot.id,
      email: (data['email'] as String?) ?? '',
      role: (data['role'] as String?) ?? 'viewer',
      invitedBy: (data['invitedBy'] as String?) ?? '',
      status: _parseStatus(data['status']),
      createdAt: _parseTimestamp(data['createdAt']),
      expiresAt: data['expiresAt'] != null ? _parseTimestamp(data['expiresAt']) : null,
      invitedUsername: data['invitedUsername'] as String?,
    );
  }

  static WorkspaceInvitationStatus _parseStatus(dynamic raw) {
    final value = (raw as String?)?.toLowerCase();
    switch (value) {
      case 'accepted':
        return WorkspaceInvitationStatus.accepted;
      case 'revoked':
        return WorkspaceInvitationStatus.revoked;
      case 'expired':
        return WorkspaceInvitationStatus.expired;
      case 'pending':
      default:
        return WorkspaceInvitationStatus.pending;
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
