import 'dart:async';

import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/features/profile_setting/domain/entities/user_profile_entity.dart';
import 'package:expense_manager/features/profile_setting/domain/usecases/profile_failure_mapper.dart';
import 'package:expense_manager/features/profile_setting/domain/usecases/update_profile_usecase.dart';
import 'package:expense_manager/features/profile_setting/domain/usecases/upload_avatar_usecase.dart';
import 'package:expense_manager/features/profile_setting/domain/usecases/watch_profile_usecase.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/bloc/profile_effect.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/bloc/profile_event.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/bloc/profile_state.dart';
import 'package:flutter_core/flutter_core.dart';

@injectable
class ProfileBloc
    extends BaseBloc<ProfileEvent, ProfileState, ProfileEffect> {
  ProfileBloc(
    this._currentUser,
    this._watchProfileUseCase,
    this._updateProfileUseCase,
    this._uploadAvatarUseCase,
    this._accountActions, {
    Logger? logger,
  }) : super(const ProfileState(isLoading: true), logger: logger) {
    on<ProfileStarted>(_onStarted);
    on<ProfileProfileChanged>(_onProfileChanged);
    on<ProfileUpdateRequested>(_onUpdateRequested);
    on<ProfileAvatarSelected>(_onAvatarSelected);
    on<ProfileSignOutRequested>(_onSignOutRequested);
    on<ProfileFailed>(_onFailed);
  }

  final CurrentUser _currentUser;
  final WatchProfileUseCase _watchProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final UploadAvatarUseCase _uploadAvatarUseCase;
  final AccountActions _accountActions;

  StreamSubscription<UserProfileEntity?>? _profileSubscription;
  CurrentUserSnapshot? _userSnapshot;
  String? _uid;

  Future<void> _onStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    _userSnapshot = _currentUser.now();
    final uid = _userSnapshot?.uid;
    if (uid == null || uid.isEmpty) {
      const message = 'User session expired';
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: message,
        ),
      );
      emitEffect(const ProfileShowErrorEffect(message));
      return;
    }
    _uid = uid;

    final fallback = _fallbackProfile();
    emit(state.copyWith(profile: fallback, isLoading: true, clearError: true));

    _profileSubscription ??=
        _watchProfileUseCase(WatchProfileParams(uid)).listen(
      (profile) {
        final merged = profile == null
            ? _fallbackProfile()
            : _mergeWithSnapshot(profile);
        add(ProfileProfileChanged(merged));
      },
      onError: (Object error, StackTrace stackTrace) {
        final failure = mapProfileError(error, stackTrace);
        add(ProfileFailed(failure.message ?? failure.code));
      },
    );
  }

  void _onProfileChanged(
    ProfileProfileChanged event,
    Emitter<ProfileState> emit,
  ) {
    emit(
      state.copyWith(
        profile: event.profile,
        isLoading: false,
        clearError: true,
      ),
    );
  }

  Future<void> _onUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final current = state.profile;
    if (current == null) {
      emitEffect(const ProfileShowErrorEffect('Profile not loaded'));
      return;
    }

    final updated = current.copyWith(
      displayName: event.displayName?.trim().isEmpty ?? true
          ? current.displayName
          : event.displayName?.trim(),
      address: event.address?.trim(),
    );

    await runResult<void>(
      emit: emit,
      task: () =>
          _updateProfileUseCase(UpdateProfileParams(updated)),
      onStart: (state) => state.copyWith(isSaving: true, clearError: true),
      onOk: (state, _) => state.copyWith(
        profile: updated,
        isSaving: false,
      ),
      onErr: (currentState, failure) {
        final message = failure.message ?? failure.code;
        emit(
          currentState.copyWith(
            isSaving: false,
            errorMessage: message,
          ),
        );
        emitEffect(ProfileShowErrorEffect(message));
      },
      trackKey: 'profile.update',
      spanName: 'profile.update',
    );
  }

  Future<void> _onAvatarSelected(
    ProfileAvatarSelected event,
    Emitter<ProfileState> emit,
  ) async {
    final profile = state.profile;
    final uid = _uid;
    if (profile == null || uid == null) {
      emitEffect(const ProfileShowErrorEffect('Profile not loaded'));
      return;
    }

    String? uploadedUrl;
    await runResult<String?>(
      emit: emit,
      task: () => _uploadAvatarUseCase(
        UploadAvatarParams(
          uid: uid,
          bytes: event.bytes,
          fileName: event.fileName,
        ),
      ),
      onStart: (state) => state.copyWith(
        isUploadingAvatar: true,
        clearError: true,
      ),
      onOk: (state, url) {
        uploadedUrl = url;
        return state.copyWith(
          isUploadingAvatar: false,
        );
      },
      onErr: (currentState, failure) {
        final message = failure.message ?? failure.code;
        emit(
          currentState.copyWith(
            isUploadingAvatar: false,
            errorMessage: message,
          ),
        );
        emitEffect(ProfileShowErrorEffect(message));
      },
      trackKey: 'profile.avatar.upload',
      spanName: 'profile.avatar.upload',
    );

    if (uploadedUrl == null) {
      return;
    }

    final updated = profile.copyWith(avatarUrl: uploadedUrl);
    await runResult<void>(
      emit: emit,
      task: () =>
          _updateProfileUseCase(UpdateProfileParams(updated)),
      onStart: (state) => state.copyWith(isSaving: true, clearError: true),
      onOk: (state, _) => state.copyWith(
        profile: updated,
        isSaving: false,
      ),
      onErr: (currentState, failure) {
        final message = failure.message ?? failure.code;
        emit(
          currentState.copyWith(
            isSaving: false,
            errorMessage: message,
          ),
        );
        emitEffect(ProfileShowErrorEffect(message));
      },
      trackKey: 'profile.avatar.update',
      spanName: 'profile.avatar.update',
    );
  }

  Future<void> _onSignOutRequested(
    ProfileSignOutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    await runResult<void>(
      emit: emit,
      task: () => Result.guard<void>(
        _accountActions.signOut,
        mapProfileError,
      ),
      onStart: (state) => state.copyWith(isSaving: true, clearError: true),
      onOk: (state, _) {
        emitEffect(const ProfileSignedOutEffect());
        return state.copyWith(isSaving: false);
      },
      onErr: (currentState, failure) {
        final message = failure.message ?? failure.code;
        emit(
          currentState.copyWith(
            isSaving: false,
            errorMessage: message,
          ),
        );
        emitEffect(ProfileShowErrorEffect(message));
      },
      trackKey: 'profile.signOut',
      spanName: 'profile.signOut',
    );
  }

  void _onFailed(
    ProfileFailed event,
    Emitter<ProfileState> emit,
  ) {
    emit(
      state.copyWith(
        isLoading: false,
        errorMessage: event.message,
      ),
    );
    emitEffect(ProfileShowErrorEffect(event.message));
  }

  UserProfileEntity _fallbackProfile() {
    final snapshot = _userSnapshot;
    return UserProfileEntity(
      uid: snapshot?.uid ?? '',
      email: snapshot?.email ?? '',
      displayName: snapshot?.displayName,
      avatarUrl: snapshot?.photoUrl,
    );
  }

  UserProfileEntity _mergeWithSnapshot(UserProfileEntity incoming) {
    final fallback = _fallbackProfile();
    return incoming.copyWith(
      email: incoming.email.isNotEmpty ? incoming.email : fallback.email,
      displayName: incoming.displayName ?? fallback.displayName,
      avatarUrl: incoming.avatarUrl ?? fallback.avatarUrl,
    );
  }

  @override
  Future<void> close() async {
    await _profileSubscription?.cancel();
    return super.close();
  }
}
