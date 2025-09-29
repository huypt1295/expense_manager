import 'package:flutter_core/flutter_core.dart';

sealed class AuthEffect extends Effect {
  const AuthEffect();
}

class AuthShowErrorEffect extends AuthEffect {
  const AuthShowErrorEffect(this.message);

  final String message;
}

class NavigateToHomePage extends AuthEffect {
  const NavigateToHomePage();
}
