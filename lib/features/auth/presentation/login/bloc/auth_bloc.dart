import 'package:expense_manager/core/domain/entities/user_entity.dart';
import 'package:flutter_core/flutter_core.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(const AuthInitial()) {
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
    emit(const AuthLoading());
    (await runAsyncCatching<UserEntity?>(
      action: () => _authRepository.signInWithGoogle(),
    ))
        .when(
      success: (user) => user != null
          ? emit(AuthAuthenticated(user: user))
          : emit(const AuthError('Google sign in failed')),
      failure: (e) => emit(AuthError(e.toString())),
    );
  }

  Future<void> _onSignInWithFacebook(
    SignInWithFacebook event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    (await runAsyncCatching<UserEntity?>(
      action: () => _authRepository.signInWithFacebook(),
    ))
        .when(
      success: (user) => user != null
          ? emit(AuthAuthenticated(user: user))
          : emit(const AuthError('Facebook sign in failed')),
      failure: (e) => emit(AuthError(e.toString())),
    );
  }

  Future<void> _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    (await runAsyncCatching<void>(
      action: () => _authRepository.signOut(),
    ))
        .when(
      success: (_) => emit(const AuthUnauthenticated()),
      failure: (e) => emit(AuthError(e.toString())),
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
