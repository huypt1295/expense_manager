import 'package:expense_manager/core/domain/entities/user_entity.dart';
import 'package:flutter_core/flutter_core.dart';

enum AuthStatus { unknown, signedIn, signedOut }

class AuthState extends BaseBlocState with EquatableMixin {
  const AuthState({
    required this.status,
    required this.user,
    required this.isLoading,
    required this.errorMessage,
  });

  const AuthState.initial()
    : status = AuthStatus.unknown,
      user = null,
      isLoading = false,
      errorMessage = null;

  final AuthStatus status;
  final UserEntity? user;
  final bool isLoading;
  final String? errorMessage;

  bool get isAuthenticated => status == AuthStatus.signedIn;

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, user, isLoading, errorMessage];
}
