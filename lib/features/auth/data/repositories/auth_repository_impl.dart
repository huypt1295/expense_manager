import 'package:expense_manager/core/domain/entities/user_entity.dart';
import 'package:expense_manager/features/auth/data/datasources/firebase_auth_data_source.dart';
import 'package:expense_manager/features/auth/data/models/user_model.dart';
import 'package:expense_manager/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final FirebaseAuthDataSource _dataSource;

  @override
  Stream<UserEntity?> watchAuthState() {
    return _dataSource.authStateChanges().map(_mapModelToEntity);
  }

  @override
  Future<UserEntity?> signInWithGoogle() async {
    final user = await _dataSource.signInWithGoogle();
    return _mapModelToEntity(user);
  }

  @override
  Future<UserEntity?> signInWithFacebook() async {
    final user = await _dataSource.signInWithFacebook();
    return _mapModelToEntity(user);
  }

  @override
  Future<void> signOut() {
    return _dataSource.signOut();
  }

  UserEntity? _mapModelToEntity(UserModel? model) {
    return model?.toEntity();
  }
}
