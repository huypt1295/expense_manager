import 'effect.dart';

abstract interface class EffectsProvider<E extends Effect> {
  Stream<E> get effects;
}
