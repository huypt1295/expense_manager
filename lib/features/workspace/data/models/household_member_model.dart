import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/features/workspace/domain/entities/household_member_entity.dart';

class HouseholdMemberModel {
  const HouseholdMemberModel({
    required this.userId,
    required this.displayName,
    required this.email,
    required this.role,
    required this.status,
    required this.joinedAt,
  });

  final String userId;
  final String displayName;
  final String email;
  final String role;
  final HouseholdMemberStatus status;
  final DateTime joinedAt;

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'displayName': displayName,
      'email': email,
      'role': role,
      'status': status.name,
      'joinedAt': Timestamp.fromDate(joinedAt),
    };
  }

  WorkspaceMemberEntity toEntity() {
    return WorkspaceMemberEntity(
      userId: userId,
      displayName: displayName,
      email: email,
      role: role,
      status: status,
      joinedAt: joinedAt,
    );
  }

  static HouseholdMemberModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? const <String, dynamic>{};
    return HouseholdMemberModel(
      userId: snapshot.id,
      displayName: (data['displayName'] as String?) ?? '',
      email: (data['email'] as String?) ?? '',
      role: (data['role'] as String?) ?? 'viewer',
      status: _parseStatus(data['status']),
      joinedAt: _parseTimestamp(data['joinedAt']),
    );
  }

  static HouseholdMemberStatus _parseStatus(dynamic raw) {
    final value = (raw as String?)?.toLowerCase();
    switch (value) {
      case 'pendingremoval':
      case 'pending_removal':
      case 'pending-removal':
        return HouseholdMemberStatus.pendingRemoval;
      case 'active':
      default:
        return HouseholdMemberStatus.active;
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
