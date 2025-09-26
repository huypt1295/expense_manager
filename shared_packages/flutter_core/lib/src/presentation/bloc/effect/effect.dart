import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_core/src/presentation/bloc/effect/effect_provider.dart' show EffectsProvider;

/// Marker interface describing a one-off presentation side effect.
///
/// Features are expected to declare domain-specific sealed classes that extend
/// this interface and capture the payload required to react in the UI.
abstract interface class Effect {
  const Effect();
}

mixin EffectEmitter<E extends Effect> implements EffectsProvider<E> {
  final StreamController<E> _effectCtrl = StreamController<E>.broadcast();

  @override
  Stream<E> get effects => _effectCtrl.stream;

  /// Emits a new [effect] to any registered listeners if the stream controller
  /// is still active.
  @protected
  void emitEffect(E effect) {
    if (!_effectCtrl.isClosed) _effectCtrl.add(effect);
  }

  @mustCallSuper
  /// Closes the underlying stream controller. Call from `close`/`dispose` to
  /// avoid memory leaks.
  void disposeEffects() {
    _effectCtrl.close();
  }
}
