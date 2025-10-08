import 'dart:async';
import 'dart:typed_data';

import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/features/profile_setting/domain/entities/user_profile_entity.dart';
import 'package:expense_manager/features/profile_setting/domain/repositories/user_profile_repository.dart';
import 'package:expense_manager/features/profile_setting/domain/usecases/update_profile_usecase.dart';
import 'package:expense_manager/features/profile_setting/domain/usecases/upload_avatar_usecase.dart';
import 'package:expense_manager/features/profile_setting/domain/usecases/watch_profile_usecase.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/bloc/profile_bloc.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/bloc/profile_event.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/bloc/profile_state.dart';
import 'package:flutter_core/flutter_core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';

class _FakeCurrentUser implements CurrentUser {
  _FakeCurrentUser(this.snapshot);

  CurrentUserSnapshot? snapshot;
  final StreamController<CurrentUserSnapshot?> _controller =
      StreamController<CurrentUserSnapshot?>.broadcast(sync: true);

  @override
  CurrentUserSnapshot? now() => snapshot;

  @override
  Stream<CurrentUserSnapshot?> watch() => _controller.stream;

  void emit(CurrentUserSnapshot? value) {
    snapshot = value;
    _controller.add(value);
  }

  Future<void> close() async {
    await _controller.close();
  }
}

class _FakeUserProfileRepository implements UserProfileRepository {
  final StreamController<UserProfileEntity?> controller =
      StreamController<UserProfileEntity?>.broadcast(sync: true);

  Future<void> Function(UserProfileEntity entity)? updateImpl;
  Future<String?> Function(String uid, Uint8List bytes, {String? fileName})?
      uploadImpl;

  @override
  Stream<UserProfileEntity?> watchProfile(String uid) => controller.stream;

  @override
  Future<UserProfileEntity?> getProfile(String uid) async => null;

  @override
  Future<void> updateProfile(UserProfileEntity entity) async {
    if (updateImpl != null) {
      await updateImpl!(entity);
    }
  }

  @override
  Future<String?> uploadAvatar(
    String uid,
    Uint8List bytes, {
    String? fileName,
  }) async {
    if (uploadImpl != null) {
      return await uploadImpl!(uid, bytes, fileName: fileName);
    }
    return null;
  }

  void emit(UserProfileEntity? entity) {
    controller.add(entity);
  }

  Future<void> close() async {
    await controller.close();
  }
}

class _FakeAccountActions implements AccountActions {
  Future<void> Function()? signOutImpl;

  @override
  Future<void> signOut() async {
    if (signOutImpl != null) {
      await signOutImpl!();
    }
  }
}

UserProfileEntity _profile(String uid) => UserProfileEntity(
      uid: uid,
      email: '',
      displayName: 'Remote Name',
      address: 'Remote Address',
      avatarUrl: null,
    );

Future<void> _pumpEventQueue() async {
  await Future<void>.delayed(Duration.zero);
}

void main() {
  late _FakeCurrentUser currentUser;
  late _FakeUserProfileRepository repository;
  late _FakeAccountActions accountActions;
  late ProfileBloc bloc;

  setUp(() {
    currentUser = _FakeCurrentUser(
      const CurrentUserSnapshot(
        uid: 'uid',
        displayName: 'Alice',
        email: 'alice@example.com',
        photoUrl: 'avatar.png',
      ),
    );
    repository = _FakeUserProfileRepository();
    accountActions = _FakeAccountActions();
    bloc = ProfileBloc(
      currentUser,
      WatchProfileUseCase(repository),
      UpdateProfileUseCase(repository),
      UploadAvatarUseCase(repository),
      accountActions,
    );
  });

  tearDown(() async {
    await bloc.close();
    await currentUser.close();
    await repository.close();
  });

  test('emits error when current user is missing', () async {
    currentUser.snapshot = const CurrentUserSnapshot(uid: null);

    final expectation = expectLater(
      bloc.stream,
      emits(
        isA<ProfileState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having(
              (s) => s.errorMessage,
              'error',
              'User session expired',
            ),
      ),
    );

    bloc.add(const ProfileStarted());

    await expectation;
  });

  test('merges remote profile with current user snapshot', () async {
    final expectation = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<ProfileState>()
            .having((s) => s.isLoading, 'isLoading', true)
            .having(
              (s) => s.profile?.email,
              'fallback email',
              'alice@example.com',
            ),
        isA<ProfileState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.profile?.displayName, 'displayName', 'Remote Name')
            .having((s) => s.profile?.email, 'email', 'alice@example.com')
            .having((s) => s.profile?.avatarUrl, 'avatar', 'avatar.png'),
      ]),
    );

    bloc.add(const ProfileStarted());
    await _pumpEventQueue();

    repository.emit(_profile('uid'));

    await expectation;
  });

  test('update request trims values and delegates to repository', () async {
    bloc.add(const ProfileStarted());
    await _pumpEventQueue();
    final ready = bloc.stream.firstWhere(
      (state) => !state.isLoading && state.profile != null,
    );
    repository.emit(_profile('uid'));
    await _pumpEventQueue();
    await ready;

    UserProfileEntity? updated;
    repository.updateImpl = (entity) async {
      updated = entity;
    };

    final emitted = <ProfileState>[];
    final sub = bloc.stream.listen(emitted.add);
    addTearDown(sub.cancel);

    bloc.add(
      const ProfileUpdateRequested(
        displayName: '  Bob  ',
        address: ' 123 Street ',
      ),
    );

    await _pumpEventQueue();
    await _pumpEventQueue();

    expect(emitted.any((state) => state.isSaving), isTrue);
    expect(
      emitted.any(
        (state) => !state.isSaving && state.profile?.displayName == 'Bob',
      ),
      isTrue,
    );
    expect(updated, isNotNull);
    expect(updated!.displayName, 'Bob');
    expect(updated!.address, '123 Street');
  });

  test('avatar selection uploads and updates profile', () async {
    bloc.add(const ProfileStarted());
    await _pumpEventQueue();
    final ready = bloc.stream.firstWhere(
      (state) => !state.isUploadingAvatar && state.profile != null,
    );
    repository.emit(_profile('uid'));
    await _pumpEventQueue();
    await ready;

    repository.uploadImpl = (uid, bytes, {fileName}) async {
      expect(uid, 'uid');
      expect(bytes, Uint8List.fromList([1, 2, 3]));
      expect(fileName, 'avatar.png');
      return 'https://cdn/avatar.png';
    };

    UserProfileEntity? updated;
    repository.updateImpl = (entity) async {
      updated = entity;
    };

    final emitted = <ProfileState>[];
    final sub = bloc.stream.listen(emitted.add);
    addTearDown(sub.cancel);

    bloc.add(
      ProfileAvatarSelected(
        bytes: Uint8List.fromList([1, 2, 3]),
        fileName: 'avatar.png',
      ),
    );

    await _pumpEventQueue();
    await _pumpEventQueue();
    await _pumpEventQueue();

    expect(emitted.any((state) => state.isUploadingAvatar), isTrue);
    expect(
      emitted.any((state) =>
          !state.isUploadingAvatar && state.profile?.avatarUrl == 'https://cdn/avatar.png'),
      isTrue,
    );
    expect(emitted.any((state) => state.isSaving), isTrue);
    expect(
      emitted.any((state) =>
          !state.isSaving && state.profile?.avatarUrl == 'https://cdn/avatar.png'),
      isTrue,
    );
    expect(updated?.avatarUrl, 'https://cdn/avatar.png');
  });

  test('sign out delegates to account actions', () async {
    var called = false;
    accountActions.signOutImpl = () async {
      called = true;
    };

    final expectation = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<ProfileState>().having((s) => s.isSaving, 'saving', true),
        isA<ProfileState>().having((s) => s.isSaving, 'saving', false),
      ]),
    );

    bloc.add(const ProfileSignOutRequested());

    await expectation;
    expect(called, isTrue);
  });
}
