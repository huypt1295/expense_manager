import 'package:expense_manager/features/profile_setting/domain/entities/user_profile_entity.dart';
import 'package:expense_manager/features/profile_setting/domain/repositories/user_profile_repository.dart';
import 'package:expense_manager/features/profile_setting/domain/usecases/profile_failure_mapper.dart';
import 'package:flutter_core/flutter_core.dart';

class UpdateProfileParams {
  const UpdateProfileParams(this.entity);

  final UserProfileEntity entity;
}

@injectable
class UpdateProfileUseCase extends BaseUseCase<UpdateProfileParams, void> {
  UpdateProfileUseCase(this._repository);

  final UserProfileRepository _repository;

  @override
  Future<Result<void>> call(UpdateProfileParams params) {
    return Result.guard<void>(
      () => _repository.updateProfile(params.entity),
      mapProfileError,
    );
  }
}
