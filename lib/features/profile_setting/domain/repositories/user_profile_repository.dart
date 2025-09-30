import 'dart:typed_data';

import 'package:expense_manager/features/profile_setting/domain/entities/user_profile_entity.dart';
import 'package:flutter_core/flutter_core.dart';

abstract class UserProfileRepository extends Repository {
  Stream<UserProfileEntity?> watchProfile(String uid);

  Future<UserProfileEntity?> getProfile(String uid);

  Future<void> updateProfile(UserProfileEntity entity);

  Future<String?> uploadAvatar(
    String uid,
    Uint8List bytes, {
    String? fileName,
  });
}
