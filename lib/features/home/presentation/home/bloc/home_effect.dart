import 'package:flutter_core/flutter_core.dart';

sealed class HomeEffect extends Effect {
  const HomeEffect();
}

/// Extend this class when the HomeBloc needs to trigger a one-off action
/// on the UI layer (e.g. show a toast, navigate, etc.).
class HomeShowErrorEffect extends HomeEffect {
  final String message;

  const HomeShowErrorEffect(this.message);
}
