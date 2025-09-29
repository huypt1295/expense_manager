import 'package:expense_manager/core/domain/entities/user_entity.dart';
import 'package:expense_manager/features/profile_setting/data/models/user_model.dart';
import 'package:expense_manager/features/profile_setting/domain/repositories/user_repository.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

@Singleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  @override
  Future<UserEntity> getUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw AuthException('User not authenticated', tokenExpired: true);
      }

      return _mapFirebaseUserToEntity(firebaseUser);
    } on FirebaseAuthException catch (error) {
      throw AuthException(
        error.message ?? 'Unable to retrieve user profile',
        tokenExpired: error.code == 'user-not-found' ||
            error.code == 'user-token-expired',
      );
    }
  }

  UserEntity _mapFirebaseUserToEntity(User user) {
    final metadata = user.metadata;
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoURL: user.photoURL,
      providerId: user.providerData.isNotEmpty
          ? user.providerData.first.providerId
          : null,
      createdAt: metadata.creationTime?.toIso8601String(),
      updatedAt: metadata.lastSignInTime?.toIso8601String(),
    ).toEntity();
  }
}
