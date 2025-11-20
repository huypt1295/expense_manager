import 'package:equatable/equatable.dart';

enum WorkspaceInvitationStatus {
  pending,
  accepted,
  revoked,
  expired,
}

class WorkspaceInvitationEntity extends Equatable {
  const WorkspaceInvitationEntity({
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

  WorkspaceInvitationEntity copyWith({
    String? id,
    String? email,
    String? role,
    String? invitedBy,
    WorkspaceInvitationStatus? status,
    DateTime? createdAt,
    DateTime? expiresAt,
    String? invitedUsername,
  }) {
    return WorkspaceInvitationEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      invitedBy: invitedBy ?? this.invitedBy,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      invitedUsername: invitedUsername ?? this.invitedUsername,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        email,
        role,
        invitedBy,
        status,
        createdAt,
        expiresAt,
        invitedUsername,
      ];
}
