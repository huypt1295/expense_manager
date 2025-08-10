import 'package:expense_manager/core/constants/data_constant.dart';
import 'package:expense_manager/core/constants/mock_data.dart';
import 'package:expense_manager/core/domain/entities/user_entity.dart';
import 'package:expense_manager/features/profile_setting/data/models/user_model.dart';
import 'package:expense_manager/features/profile_setting/domain/repositories/user_repository.dart';
import 'package:flutter_core/flutter_core.dart';

@Singleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  @override
  Future<UserEntity> getUser() async {
    final result = kMock ? MockData.mockUser : null;
    if (result != null) {
      return UserModel.fromJson(result).toEntity();
    }
    return Future.error('No data found');
  }
}
