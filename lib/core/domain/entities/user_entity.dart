import 'package:flutter_core/flutter_core.dart';

class UserEntity extends BaseEntity with EquatableMixin {
  final String id;
  final String email;
  final String? displayName;
  final String? photoURL;
  final String? providerId;
  final String? createdAt;
  final String? updatedAt;

  UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoURL,
    this.providerId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    photoURL,
    providerId,
    createdAt,
    updatedAt,
  ];

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'providerId': providerId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  UserEntity copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    String? providerId,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      providerId: providerId ?? this.providerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
