import 'package:expense_manager/features/profile_setting/domain/entities/user_profile_entity.dart';
import 'package:expense_manager/features/profile_setting/domain/repositories/user_profile_repository.dart';
import 'package:expense_manager/features/profile_setting/domain/usecases/profile_failure_mapper.dart';
import 'package:flutter_core/flutter_core.dart';

class GetProfileParams {
  const GetProfileParams(this.uid);

  final String uid;
}

@injectable
class GetProfileUseCase
    extends BaseUseCase<GetProfileParams, UserProfileEntity?> {
  GetProfileUseCase(this._repository);

  final UserProfileRepository _repository;

  @override
  Future<Result<UserProfileEntity?>> call(GetProfileParams params) {
    return Result.guard<UserProfileEntity?>(
      () => _repository.getProfile(params.uid),
      mapProfileError,
    );
  }
}
