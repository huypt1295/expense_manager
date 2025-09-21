import 'package:expense_manager/core/domain/entities/user_entity.dart';
import 'package:expense_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_core/flutter_core.dart';

@singleton
class SignInWithGoogleUseCase extends BaseUseCase<NoParam, UserEntity?> {
  final AuthRepository repository;

  SignInWithGoogleUseCase(this.repository);

  @override
  Future<UserEntity?> call(NoParam params) async {
    return await repository.signInWithGoogle();
  }
}

