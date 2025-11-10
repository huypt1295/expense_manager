import 'package:equatable/equatable.dart';

enum HouseholdMemberStatus {
  active,
  pendingRemoval,
}

class WorkspaceMemberEntity extends Equatable {
  const WorkspaceMemberEntity({
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

  bool get isOwner => role.toLowerCase() == 'owner';

  bool get isEditor => role.toLowerCase() == 'editor';

  bool get isViewer => role.toLowerCase() == 'viewer';

  WorkspaceMemberEntity copyWith({
    String? userId,
    String? displayName,
    String? email,
    String? role,
    HouseholdMemberStatus? status,
    DateTime? joinedAt,
  }) {
    return WorkspaceMemberEntity(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        userId,
        displayName,
        email,
        role,
        status,
        joinedAt,
      ];
}
