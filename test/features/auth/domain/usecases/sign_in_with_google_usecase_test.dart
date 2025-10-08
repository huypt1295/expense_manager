import 'package:expense_manager/core/domain/entities/user_entity.dart';
import 'package:expense_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:expense_manager/features/auth/domain/usecases/sign_in_with_fb_usecase.dart';
import 'package:expense_manager/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:expense_manager/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:flutter_core/flutter_core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  Object? googleError;
  Object? facebookError;
  Object? signOutError;
  UserEntity? googleUser;
  UserEntity? facebookUser;
  bool signOutCalled = false;

  @override
  Stream<UserEntity?> watchAuthState() => const Stream.empty();

  @override
  Future<UserEntity?> signInWithGoogle() async {
    if (googleError != null) throw googleError!;
    return googleUser;
  }

  @override
  Future<UserEntity?> signInWithFacebook() async {
    if (facebookError != null) throw facebookError!;
    return facebookUser;
  }

  @override
  Future<void> signOut() async {
    if (signOutError != null) throw signOutError!;
    signOutCalled = true;
  }
}

void main() {
  group('SignInWithGoogleUseCase', () {
    late _FakeAuthRepository repository;
    late SignInWithGoogleUseCase useCase;

    setUp(() {
      repository = _FakeAuthRepository();
      useCase = SignInWithGoogleUseCase(repository);
    });

    test('returns success when repository resolves user', () async {
      final user = UserEntity(id: '1', email: 'test@example.com');
      repository.googleUser = user;

      final result = await useCase(NoParam());

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, user);
    });

    test('maps AuthException to AuthFailure', () async {
      repository.googleError = AuthException('token expired');

      final result = await useCase(NoParam());

      expect(result.isFailure, isTrue);
      final failure = result.failureOrNull;
      expect(failure, isA<AuthFailure>());
      expect(failure?.message, 'token expired');
    });

    test('maps unknown error to UnknownFailure', () async {
      repository.googleError = Exception('bad');

      final result = await useCase(NoParam());

      expect(result.isFailure, isTrue);
      final failure = result.failureOrNull;
      expect(failure, isA<UnknownFailure>());
      expect(failure?.message, contains('Exception: bad'));
    });
  });

  group('SignInWithFacebookUseCase', () {
    late _FakeAuthRepository repository;
    late SignInWithFacebookUseCase useCase;

    setUp(() {
      repository = _FakeAuthRepository();
      useCase = SignInWithFacebookUseCase(repository);
    });

    test('returns success when repository resolves user', () async {
      final user = UserEntity(id: 'fb', email: 'fb@example.com');
      repository.facebookUser = user;

      final result = await useCase(NoParam());

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, user);
    });

    test('maps AuthException to AuthFailure', () async {
      repository.facebookError = AuthException('cancelled');

      final result = await useCase(NoParam());

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<AuthFailure>());
    });

    test('maps unknown error to UnknownFailure', () async {
      repository.facebookError = Exception('fb-error');

      final result = await useCase(NoParam());

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<UnknownFailure>());
    });
  });

  group('SignOutUseCase', () {
    late _FakeAuthRepository repository;
    late SignOutUseCase useCase;

    setUp(() {
      repository = _FakeAuthRepository();
      useCase = SignOutUseCase(repository);
    });

    test('returns success when repository signOut completes', () async {
      final result = await useCase(NoParam());

      expect(result.isSuccess, isTrue);
      expect(repository.signOutCalled, isTrue);
    });

    test('maps AuthException to AuthFailure', () async {
      repository.signOutError = AuthException('expired');

      final result = await useCase(NoParam());

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<AuthFailure>());
    });

    test('maps unknown error to UnknownFailure', () async {
      repository.signOutError = Exception('boom');

      final result = await useCase(NoParam());

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<UnknownFailure>());
    });
  });
}
