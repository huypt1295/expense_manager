import 'package:expense_manager/core/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> signInWithGoogle();
  Future<UserEntity?> signInWithFacebook();
  Future<void> signOut();
  Stream<UserEntity?> get authStateChanges;
  UserEntity? get currentUser;
}
