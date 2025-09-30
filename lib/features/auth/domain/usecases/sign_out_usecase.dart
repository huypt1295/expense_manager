import 'package:expense_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;

@singleton
class SignOutUseCase extends BaseUseCase<NoParam, void> {
  SignOutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(NoParam params) {
    return Result.guard<void>(_repository.signOut, _mapToFailure);
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
