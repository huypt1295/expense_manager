import 'package:flutter_core/flutter_core.dart';

class UserProfileEntity extends BaseEntity with EquatableMixin {
  UserProfileEntity({
    required this.uid,
    required this.email,
    this.displayName,
    this.address,
    this.avatarUrl,
    this.defaultWorkspaceId,
  });

  final String uid;
  final String email;
  final String? displayName;
  final String? address;
  final String? avatarUrl;
  final String? defaultWorkspaceId;

  @override
  List<Object?> get props => <Object?>[
        uid,
        email,
        displayName,
        address,
        avatarUrl,
        defaultWorkspaceId,
      ];

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'address': address,
        'avatarUrl': avatarUrl,
        'defaultWorkspaceId': defaultWorkspaceId,
      };

  UserProfileEntity copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? address,
    String? avatarUrl,
    String? defaultWorkspaceId,
  }) {
    return UserProfileEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      address: address ?? this.address,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      defaultWorkspaceId: defaultWorkspaceId ?? this.defaultWorkspaceId,
    );
  }
}
