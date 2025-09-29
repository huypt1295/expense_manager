import 'package:flutter_core/flutter_core.dart';

abstract class AuthEvent extends BaseBlocEvent with EquatableMixin {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInWithGoogle extends AuthEvent {
  const SignInWithGoogle();
}

class SignInWithFacebook extends AuthEvent {
  const SignInWithFacebook();
}

class SignOut extends AuthEvent {
  const SignOut();
}

class CheckAuthState extends AuthEvent {
  const CheckAuthState();
}
