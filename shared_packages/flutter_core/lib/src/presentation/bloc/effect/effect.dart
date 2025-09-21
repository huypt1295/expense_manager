import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_core/src/presentation/bloc/effect/effect_provider.dart' show EffectsProvider;

/// Marker interface để khai báo domain của side-effects.
/// Tùy feature bạn tạo sealed classes cụ thể implement interface này.
abstract interface class Effect {
  const Effect();
}

mixin EffectEmitter<E extends Effect> implements EffectsProvider<E> {
  final StreamController<E> _effectCtrl = StreamController<E>.broadcast();

  @override
  Stream<E> get effects => _effectCtrl.stream;

  @protected
  void emitEffect(E effect) {
    if (!_effectCtrl.isClosed) _effectCtrl.add(effect);
  }

  @mustCallSuper
  void disposeEffects() {
    _effectCtrl.close();
  }
}
