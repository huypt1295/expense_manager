import 'package:expense_manager/features/profile_setting/domain/entities/user_profile_entity.dart';
import 'package:expense_manager/features/profile_setting/domain/repositories/user_profile_repository.dart';
import 'package:flutter_core/flutter_core.dart';

class WatchProfileParams {
  const WatchProfileParams(this.uid);

  final String uid;
}

@singleton
class WatchProfileUseCase {
  WatchProfileUseCase(this._repository);

  final UserProfileRepository _repository;

  Stream<UserProfileEntity?> call(WatchProfileParams params) {
    return _repository.watchProfile(params.uid);
  }
}
