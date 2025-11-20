import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_member_entity.dart';

class WorkspaceMemberModel {
  const WorkspaceMemberModel({
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
  final WorkspaceMemberStatus status;
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

  static WorkspaceMemberModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? const <String, dynamic>{};
    return WorkspaceMemberModel(
      userId: snapshot.id,
      displayName: (data['displayName'] as String?) ?? '',
      email: (data['email'] as String?) ?? '',
      role: (data['role'] as String?) ?? 'viewer',
      status: _parseStatus(data['status']),
      joinedAt: _parseTimestamp(data['joinedAt']),
    );
  }

  static WorkspaceMemberModel fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return _fromDocData(doc.id, data, isUserDefined: true);
  }

  static WorkspaceMemberModel _fromDocData(
      String id,
      Map<String, dynamic> data, {
        required bool isUserDefined,
      }) {
    return WorkspaceMemberModel(
      userId: id,
      displayName: (data['displayName'] as String?) ?? '',
      email: (data['email'] as String?) ?? '',
      role: (data['role'] as String?) ?? 'viewer',
      status: _parseStatus(data['status']),
      joinedAt: _parseTimestamp(data['joinedAt']),
    );
  }

  static WorkspaceMemberStatus _parseStatus(dynamic raw) {
    final value = (raw as String?)?.toLowerCase();
    switch (value) {
      case 'pendingremoval':
      case 'pending_removal':
      case 'pending-removal':
        return WorkspaceMemberStatus.pendingRemoval;
      case 'active':
      default:
        return WorkspaceMemberStatus.active;
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
