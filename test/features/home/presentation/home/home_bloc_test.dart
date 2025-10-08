import 'package:expense_manager/core/domain/entities/user_entity.dart';
import 'package:expense_manager/features/home/presentation/home/bloc/home_bloc.dart';
import 'package:expense_manager/features/home/presentation/home/bloc/home_event.dart';
import 'package:expense_manager/features/home/presentation/home/bloc/home_state.dart';
import 'package:expense_manager/features/profile_setting/domain/repositories/user_repository.dart';
import 'package:expense_manager/features/profile_setting/domain/usecases/get_user_usecase.dart';
import 'package:flutter_core/flutter_core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';

class _FakeUserRepository implements UserRepository {
  Future<UserEntity> Function()? getUserImpl;

  @override
  Future<UserEntity> getUser() async {
    if (getUserImpl != null) {
      return await getUserImpl!();
    }
    return UserEntity(id: 'id', email: 'email@example.com');
  }
}

void main() {
  group('HomeBloc', () {
    late _FakeUserRepository repository;
    late HomeBloc bloc;

    setUp(() {
      repository = _FakeUserRepository();
      bloc = HomeBloc(GetUserUseCase(repository));
    });

    tearDown(() async {
      await bloc.close();
    });

    test('emits loading then loaded when user is fetched', () async {
      final user = UserEntity(id: 'u1', email: 'user@example.com');
      repository.getUserImpl = () async => user;

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<HomeLoading>(),
          isA<HomeLoaded>().having((state) => state.user, 'user', user),
        ]),
      );

      bloc.add(const HomeLoadData());

      await expectation;
    });

    test('emits error when repository throws', () async {
      repository.getUserImpl = () async {
        throw AuthException('unauthenticated');
      };

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<HomeLoading>(),
          isA<HomeError>().having((state) => state.message, 'message', 'unauthenticated'),
        ]),
      );

      bloc.add(const HomeLoadData());

      await expectation;
    });
  });
}
