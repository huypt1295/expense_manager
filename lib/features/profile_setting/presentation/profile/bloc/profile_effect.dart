import 'package:flutter_core/flutter_core.dart';

sealed class ProfileEffect extends Effect {
  const ProfileEffect();
}

class ProfileShowErrorEffect extends ProfileEffect {
  const ProfileShowErrorEffect(this.message);

  final String message;
}

class ProfileSignedOutEffect extends ProfileEffect {
  const ProfileSignedOutEffect();
}
