import 'dart:async';

import 'package:expense_manager/core/domain/entities/user_entity.dart';
import 'package:flutter_core/flutter_core.dart';

import '../../../domain/usecases/sign_in_with_fb_usecase.dart';
import '../../../domain/usecases/sign_in_with_google_usecase.dart';
import '../../../domain/usecases/sign_out_usecase.dart';
import '../../../domain/usecases/watch_auth_state_usecase.dart';
import 'auth_effect.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@singleton
class AuthBloc extends BaseBloc<AuthEvent, AuthState, AuthEffect> {
  AuthBloc(
    this._signInWithGoogleUseCase,
    this._signInWithFacebookUseCase,
    this._signOutUseCase,
    this._watchAuthStateUseCase, {
    Logger? logger,
  }) : super(const AuthState.initial(), logger: logger) {
    on<AuthEventWatchAuthState>(_onWatchAuthState);
    on<AuthEventStateChanged>(_onAuthStateChanged);
    on<AuthEventStreamFailed>(_onAuthStreamFailed);
    on<AuthEventSignInWithGoogle>(_onSignInWithGoogle);
    on<AuthEventSignInWithFacebook>(_onSignInWithFacebook);
    on<AuthEventSignOut>(_onSignOut);
  }

  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SignInWithFacebookUseCase _signInWithFacebookUseCase;
  final SignOutUseCase _signOutUseCase;
  final WatchAuthStateUseCase _watchAuthStateUseCase;

  StreamSubscription<UserEntity?>? _authStateSubscription;

  Future<void> _onWatchAuthState(
    AuthEventWatchAuthState event,
    Emitter<AuthState> emit,
  ) async {
    if (_authStateSubscription != null) {
      return;
    }

    _authStateSubscription = _watchAuthStateUseCase(NoParam()).listen(
      (user) => add(AuthEventStateChanged(user)),
      onError: (error, stackTrace) {
        final message = error is Failure
            ? (error.message ?? error.code)
            : error.toString();
        add(AuthEventStreamFailed(message));
      },
    );
  }

  void _onAuthStateChanged(
    AuthEventStateChanged event,
    Emitter<AuthState> emit,
  ) {
    final status = event.user == null
        ? AuthStatus.signedOut
        : AuthStatus.signedIn;
    emit(
      state.copyWith(
        status: status,
        user: event.user,
        isLoading: false,
        clearError: true,
      ),
    );
  }

  void _onAuthStreamFailed(
    AuthEventStreamFailed event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(isLoading: false, errorMessage: event.message));
    emitEffect(AuthShowErrorEffect(event.message));
  }

  Future<void> _onSignInWithGoogle(
    AuthEventSignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    await runResult<UserEntity?>(
      emit: emit,
      task: () => _signInWithGoogleUseCase(NoParam()),
      onStart: (state) => state.copyWith(isLoading: true, clearError: true),
      onOk: (state, _) => state.copyWith(isLoading: false),
      onErr: (state, failure) {
        final message = failure.message ?? failure.code;
        emit(state.copyWith(isLoading: false, errorMessage: message));
        emitEffect(AuthShowErrorEffect(message));
      },
      trackKey: 'signInGoogle',
      spanName: 'auth.signIn.google',
    );
  }

  Future<void> _onSignInWithFacebook(
    AuthEventSignInWithFacebook event,
    Emitter<AuthState> emit,
  ) async {
    await runResult<UserEntity?>(
      emit: emit,
      task: () => _signInWithFacebookUseCase(NoParam()),
      onStart: (state) => state.copyWith(isLoading: true, clearError: true),
      onOk: (state, _) => state.copyWith(isLoading: false),
      onErr: (state, failure) {
        final message = failure.message ?? failure.code;
        emit(state.copyWith(isLoading: false, errorMessage: message));
        emitEffect(AuthShowErrorEffect(message));
      },
      trackKey: 'signInFacebook',
      spanName: 'auth.signIn.facebook',
    );
  }

  Future<void> _onSignOut(
    AuthEventSignOut event,
    Emitter<AuthState> emit,
  ) async {
    await runResult<void>(
      emit: emit,
      task: () => _signOutUseCase(NoParam()),
      onStart: (state) => state.copyWith(isLoading: true, clearError: true),
      onOk: (state, _) => state.copyWith(isLoading: false),
      onErr: (state, failure) {
        final message = failure.message ?? failure.code;
        emit(state.copyWith(isLoading: false, errorMessage: message));
        emitEffect(AuthShowErrorEffect(message));
      },
      trackKey: 'signOut',
      spanName: 'auth.signOut',
    );
  }

  @override
  Future<void> close() async {
    await _authStateSubscription?.cancel();
    return super.close();
  }
}
