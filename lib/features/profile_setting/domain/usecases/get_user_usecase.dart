import 'package:expense_manager/features/profile_setting/domain/entities/user_entity.dart';
import 'package:expense_manager/features/profile_setting/domain/repositories/user_repository.dart';
import 'package:flutter_core/flutter_core.dart';

@injectable
class GetUserUseCase extends BaseUseCase<void, UserEntity> {
  final UserRepository _userRepository;

  GetUserUseCase(this._userRepository);

  @override
  Future<UserEntity> call(void params) async {
    return await _userRepository.getUser();
  }
}
