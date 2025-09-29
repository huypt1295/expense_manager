import 'package:expense_manager/core/domain/entities/user_entity.dart';
import 'package:expense_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_core/src/data/exceptions/exceptions.dart'
    show AuthException;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;

@singleton
class SignInWithFacebookUseCase extends BaseUseCase<NoParam, UserEntity?> {
  SignInWithFacebookUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<UserEntity?>> call(NoParam params) {
    return Result.guard<UserEntity?>(
      () => _repository.signInWithFacebook(),
      _mapToFailure,
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
    if (error is FirebaseAuthException) {
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
