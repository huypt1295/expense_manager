import 'package:expense_manager/core/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> watchAuthState();
  Future<UserEntity?> signInWithGoogle();
  Future<UserEntity?> signInWithFacebook();
  Future<void> signOut();
}
