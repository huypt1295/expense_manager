import 'package:expense_manager/core/domain/entities/user_entity.dart';
import 'package:flutter_core/flutter_core.dart';

abstract class UserRepository extends Repository {
  Future<UserEntity> getUser();
}
