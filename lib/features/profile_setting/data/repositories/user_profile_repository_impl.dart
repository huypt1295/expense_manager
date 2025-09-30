import 'dart:typed_data';

import 'package:expense_manager/features/profile_setting/data/datasources/profile_remote_data_source.dart';
import 'package:expense_manager/features/profile_setting/data/models/user_profile_model.dart';
import 'package:expense_manager/features/profile_setting/domain/entities/user_profile_entity.dart';
import 'package:expense_manager/features/profile_setting/domain/repositories/user_profile_repository.dart';
import 'package:flutter_core/flutter_core.dart';

@LazySingleton(as: UserProfileRepository)
class UserProfileRepositoryImpl implements UserProfileRepository {
  UserProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Stream<UserProfileEntity?> watchProfile(String uid) {
    return _remoteDataSource.watchProfile(uid).map(
          (model) => model?.toEntity(),
        );
  }

  @override
  Future<UserProfileEntity?> getProfile(String uid) async {
    final model = await _remoteDataSource.fetchProfile(uid);
    return model?.toEntity();
  }

  @override
  Future<void> updateProfile(UserProfileEntity entity) {
    final model = UserProfileModel.fromEntity(entity);
    return _remoteDataSource.upsertProfile(model);
  }

  @override
  Future<String?> uploadAvatar(
    String uid,
    Uint8List bytes, {
    String? fileName,
  }) {
    return _remoteDataSource.uploadAvatar(
      uid,
      bytes,
      fileName: fileName,
    );
  }

}
