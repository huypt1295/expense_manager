import 'package:expense_manager/core/domain/entities/user_entity.dart';
import 'package:expense_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_core/flutter_core.dart';

@singleton
class WatchAuthStateUseCase {
  WatchAuthStateUseCase(this._repository);

  final AuthRepository _repository;

  Stream<UserEntity?> call(NoParam params) {
    return _repository.watchAuthState();
  }
}
