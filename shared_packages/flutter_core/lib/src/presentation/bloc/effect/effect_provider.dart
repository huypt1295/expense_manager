import 'effect.dart';

/// Exposes a stream of effects that consumer widgets can subscribe to.
abstract interface class EffectsProvider<E extends Effect> {
  /// One-shot effects emitted by the bloc/cubit.
  Stream<E> get effects;
}
