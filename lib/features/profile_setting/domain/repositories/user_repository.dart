import 'package:expense_manager/features/profile_setting/domain/entities/user_entity.dart';
import 'package:flutter_core/flutter_core.dart';

abstract class UserRepository extends Repository {
  Future<UserEntity> getUser();
}
