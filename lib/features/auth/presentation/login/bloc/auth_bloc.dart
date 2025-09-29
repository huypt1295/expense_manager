import 'package:expense_manager/core/domain/entities/user_entity.dart';
import 'package:flutter_core/flutter_core.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/usecases/sign_in_with_fb_usecase.dart';
import '../../../domain/usecases/sign_in_with_google_usecase.dart';
import 'auth_effect.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends BaseBloc<AuthEvent, AuthState, AuthEffect> {
  final AuthRepository _authRepository;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SignInWithFacebookUseCase _signInWithFacebookUseCase;

  AuthBloc(
    this._authRepository,
    this._signInWithGoogleUseCase,
    this._signInWithFacebookUseCase,
  ) : super(const AuthInitial()) {
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<SignInWithFacebook>(_onSignInWithFacebook);
    on<SignOut>(_onSignOut);
    on<CheckAuthState>(_onCheckAuthState);

    // Listen to auth state changes
    _authRepository.authStateChanges.listen((user) {
      add(const CheckAuthState());
    });
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    await runResult<UserEntity?>(
      emit: emit,
      task: () => _signInWithGoogleUseCase(NoParam()),
      onStart: (_) => const AuthLoading(),
      onOk: (_, user) => user != null
          ? AuthAuthenticated(user: user)
          : const AuthError('Google sign in failed'),
      onErr: (_, failure) {
        final message = failure.message ?? failure.code;
        emit(AuthError(message));
        emitEffect(AuthShowErrorEffect(message));
      },
      trackKey: 'signInGoogle',
      spanName: 'auth.signIn.google',
    );
  }

  Future<void> _onSignInWithFacebook(
    SignInWithFacebook event,
    Emitter<AuthState> emit,
  ) async {
    await runResult<UserEntity?>(
      emit: emit,
      task: () => _signInWithFacebookUseCase(NoParam()),
      onStart: (_) => const AuthLoading(),
      onOk: (_, user) => user != null
          ? AuthAuthenticated(user: user)
          : const AuthError('Facebook sign in failed'),
      onErr: (_, failure) {
        final message = failure.message ?? failure.code;
        emit(AuthError(message));
        emitEffect(AuthShowErrorEffect(message));
      },
      trackKey: 'signInFacebook',
      spanName: 'auth.signIn.facebook',
    );
  }

  Future<void> _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    await runResult<void>(
      emit: emit,
      task: () => Result.guard<void>(
        () => _authRepository.signOut(),
        (error, stackTrace) => UnknownFailure(
          message: error.toString(),
          cause: error,
          stackTrace: stackTrace,
        ),
      ),
      onStart: (_) => const AuthLoading(),
      onOk: (_, __) => const AuthUnauthenticated(),
      onErr: (_, failure) {
        final message = failure.message ?? failure.code;
        emit(AuthError(message));
        emitEffect(AuthShowErrorEffect(message));
      },
      trackKey: 'signOut',
      spanName: 'auth.signOut',
    );
  }

  Future<void> _onCheckAuthState(
      CheckAuthState event, Emitter<AuthState> emit) async {
    final user = _authRepository.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user: user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }
}
