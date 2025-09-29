import 'package:expense_manager/core/domain/entities/user_entity.dart';
import 'package:expense_manager/features/profile_setting/domain/repositories/user_repository.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_core/src/data/exceptions/exceptions.dart' show AuthException;

@injectable
class GetUserUseCase extends BaseUseCase<NoParam, UserEntity> {
  GetUserUseCase(this._userRepository);

  final UserRepository _userRepository;

  @override
  Future<Result<UserEntity>> call(NoParam params) {
    return Result.guard<UserEntity>(
      () => _userRepository.getUser(),
      (error, stackTrace) => _mapToFailure(error, stackTrace),
    );
  }

  Failure _mapToFailure(Object error, StackTrace stackTrace) {
    if (error is Failure) {
      return error;
    }
    if (error is AuthException) {
      return AuthFailure(
        message: error.message,
        cause: error,
        stackTrace: stackTrace,
      );
    }
    return UnknownFailure(
      message: error.toString(),
      cause: error,
      stackTrace: stackTrace,
    );
  }
}
