import 'dart:async';

import 'package:expense_manager/core/domain/entities/user_entity.dart';
import 'package:expense_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:expense_manager/features/auth/domain/usecases/sign_in_with_fb_usecase.dart';
import 'package:expense_manager/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:expense_manager/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:expense_manager/features/auth/domain/usecases/watch_auth_state_usecase.dart';
import 'package:expense_manager/features/auth/presentation/login/bloc/auth_bloc.dart';
import 'package:expense_manager/features/auth/presentation/login/bloc/auth_event.dart';
import 'package:expense_manager/features/auth/presentation/login/bloc/auth_state.dart';
import 'package:flutter_core/flutter_core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  final StreamController<UserEntity?> _controller =
      StreamController<UserEntity?>.broadcast(sync: true);

  Future<UserEntity?> Function()? signInWithGoogleImpl;
  Future<UserEntity?> Function()? signInWithFacebookImpl;
  Future<void> Function()? signOutImpl;

  bool get isClosed => _controller.isClosed;

  @override
  Stream<UserEntity?> watchAuthState() => _controller.stream;

  @override
  Future<UserEntity?> signInWithGoogle() async {
    if (signInWithGoogleImpl != null) {
      return await signInWithGoogleImpl!();
    }
    return null;
  }

  @override
  Future<UserEntity?> signInWithFacebook() async {
    if (signInWithFacebookImpl != null) {
      return await signInWithFacebookImpl!();
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    if (signOutImpl != null) {
      await signOutImpl!();
    }
  }

  void add(UserEntity? user) {
    _controller.add(user);
  }

  Future<void> close() async {
    await _controller.close();
  }
}

UserEntity _dummyUser() => UserEntity(id: '1', email: 'user@example.com');

Future<void> _pumpEventQueue() async {
  await Future<void>.delayed(Duration.zero);
}

void main() {
  late _FakeAuthRepository repository;
  late AuthBloc bloc;

  setUp(() {
    repository = _FakeAuthRepository();
    bloc = AuthBloc(
      SignInWithGoogleUseCase(repository),
      SignInWithFacebookUseCase(repository),
      SignOutUseCase(repository),
      WatchAuthStateUseCase(repository),
      null,
    );
  });

  tearDown(() async {
    await bloc.close();
    if (!repository.isClosed) {
      await repository.close();
    }
  });

  group('AuthBloc watch', () {
    test('updates state when auth stream emits user', () async {
      final expectation = expectLater(
        bloc.stream,
        emits(
          isA<AuthState>()
              .having((s) => s.status, 'status', AuthStatus.signedIn)
              .having((s) => s.user, 'user', _dummyUser())
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'error', isNull),
        ),
      );

      bloc.add(const AuthEventWatchAuthState());
      await _pumpEventQueue();

      repository.add(_dummyUser());

      await expectation;
    });

    test('emits error state when stream fails', () async {
      final expectation = expectLater(
        bloc.stream,
        emits(
          isA<AuthState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'error', 'stream failed'),
        ),
      );

      bloc.add(const AuthEventStreamFailed('stream failed'));

      await expectation;
    });
  });

  group('AuthBloc commands', () {
    test('sign-in with Google toggles loading and calls repository', () async {
      var called = false;
      repository.signInWithGoogleImpl = () async {
        called = true;
        return _dummyUser();
      };

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<AuthState>().having((s) => s.isLoading, 'isLoading', true),
          isA<AuthState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'error', isNull),
        ]),
      );

      bloc.add(const AuthEventSignInWithGoogle());

      await expectation;
      expect(called, isTrue);
    });

    test('sign-in error surfaces failure message', () async {
      repository.signInWithGoogleImpl = () async {
        throw AuthException('sign in failed');
      };

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<AuthState>().having((s) => s.isLoading, 'isLoading', true),
          isA<AuthState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'error', 'sign in failed'),
        ]),
      );

      bloc.add(const AuthEventSignInWithGoogle());

      await expectation;
    });

    test('sign-out delegates to repository', () async {
      var signOutCalled = false;
      repository.signOutImpl = () async {
        signOutCalled = true;
      };

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<AuthState>().having((s) => s.isLoading, 'isLoading', true),
          isA<AuthState>().having((s) => s.isLoading, 'isLoading', false),
        ]),
      );

      bloc.add(const AuthEventSignOut());

      await expectation;
      expect(signOutCalled, isTrue);
    });
  });
}
