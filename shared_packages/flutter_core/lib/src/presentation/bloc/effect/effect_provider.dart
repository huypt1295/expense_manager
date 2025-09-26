import 'effect.dart';

/// Contract for objects that expose a stream of one-off [Effect]s.
abstract interface class EffectsProvider<E extends Effect> {
  /// Lazily-listened stream containing all effects emitted by the provider.
  Stream<E> get effects;
}
