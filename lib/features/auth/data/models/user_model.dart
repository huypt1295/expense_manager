import 'package:expense_manager/core/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  const UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.providerId,
  });

  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? providerId;

  UserEntity toEntity() {
    return UserEntity(
      id: uid,
      email: email,
      displayName: displayName,
      photoURL: photoUrl,
      providerId: providerId,
    );
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? providerId,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      providerId: providerId ?? this.providerId,
    );
  }

  static UserModel? fromFirebaseUserNullable(User? user) {
    if (user == null) return null;
    return fromFirebaseUser(user);
  }

  static UserModel fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
      providerId: user.providerData.isNotEmpty
          ? user.providerData.first.providerId
          : null,
    );
  }
}
