import 'package:expense_manager/core/domain/entities/user_entity.dart';
import 'package:flutter_core/flutter_core.dart';

sealed class AuthEvent extends BaseBlocEvent with EquatableMixin {
  const AuthEvent();

  @override
  List<Object?> get props => const [];
}

class AuthEventWatchAuthState extends AuthEvent {
  const AuthEventWatchAuthState();
}

class AuthEventSignInWithGoogle extends AuthEvent {
  const AuthEventSignInWithGoogle();
}

class AuthEventSignInWithFacebook extends AuthEvent {
  const AuthEventSignInWithFacebook();
}

class AuthEventSignOut extends AuthEvent {
  const AuthEventSignOut();
}

class AuthEventStateChanged extends AuthEvent {
  const AuthEventStateChanged(this.user);

  final UserEntity? user;

  @override
  List<Object?> get props => [user];
}

class AuthEventStreamFailed extends AuthEvent {
  const AuthEventStreamFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
