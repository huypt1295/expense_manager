import 'package:equatable/equatable.dart';

enum HouseholdInvitationStatus {
  pending,
  accepted,
  revoked,
  expired,
}

class HouseholdInvitationEntity extends Equatable {
  const HouseholdInvitationEntity({
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

  HouseholdInvitationEntity copyWith({
    String? id,
    String? email,
    String? role,
    String? invitedBy,
    HouseholdInvitationStatus? status,
    DateTime? createdAt,
  }) {
    return HouseholdInvitationEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      invitedBy: invitedBy ?? this.invitedBy,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
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
      ];
}
