import 'package:flutter_core/flutter_core.dart';

class UserEntity extends BaseEntity with EquatableMixin {
  final String? email;
  final String? displayName;
  final String? createdAt;
  final String? updatedAt;

  UserEntity(
      {required this.email,
      required this.displayName,
      required this.createdAt,
      required this.updatedAt});

  @override
  List<Object?> get props => [email];

  @override
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "displayName": displayName,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}
