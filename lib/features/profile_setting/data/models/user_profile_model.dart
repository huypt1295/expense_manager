import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/features/profile_setting/domain/entities/user_profile_entity.dart';

class UserProfileModel {
  const UserProfileModel({
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

  UserProfileEntity toEntity() {
    return UserProfileEntity(
      uid: uid,
      email: email,
      displayName: displayName,
      address: address,
      avatarUrl: avatarUrl,
      defaultWorkspaceId: defaultWorkspaceId,
    );
  }

  Map<String, dynamic> toFirestore({bool merge = false}) {
    final map = <String, dynamic>{
      'email': email,
      'displayName': displayName,
      'address': address,
      'avatarUrl': avatarUrl,
      'defaultWorkspaceId': defaultWorkspaceId,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (!merge) {
      map['createdAt'] = FieldValue.serverTimestamp();
    }
    return map;
  }

  static UserProfileModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return UserProfileModel(
      uid: snapshot.id,
      email: (data['email'] as String?) ?? '',
      displayName: data['displayName'] as String?,
      address: data['address'] as String?,
      avatarUrl: data['avatarUrl'] as String?,
      defaultWorkspaceId: data['defaultWorkspaceId'] as String?,
    );
  }

  static UserProfileModel fromEntity(UserProfileEntity entity) {
    return UserProfileModel(
      uid: entity.uid,
      email: entity.email,
      displayName: entity.displayName,
      address: entity.address,
      avatarUrl: entity.avatarUrl,
      defaultWorkspaceId: entity.defaultWorkspaceId,
    );
  }
}
