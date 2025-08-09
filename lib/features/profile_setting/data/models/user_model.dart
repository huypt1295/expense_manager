import 'package:expense_manager/features/profile_setting/domain/entities/user_entity.dart';
import 'package:flutter_core/flutter_core.dart';

class UserModel extends BaseModel<UserEntity> {
  final String? email;
  final String? displayName;
  final String? createdAt;
  final String? updatedAt;

  UserModel(
      {required this.email,
      required this.displayName,
      required this.createdAt,
      required this.updatedAt});

  @override
  UserEntity toEntity() {
    return UserEntity(
        email: email,
        displayName: displayName,
        createdAt: createdAt,
        updatedAt: updatedAt);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "displayName": displayName,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      displayName: json['displayName'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
