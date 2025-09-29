import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_core/src/domain/analytics/analytics_service.dart'
    show AnalyticsService;

/// Marker interface describing a side-effect produced by presentation logic.
///
/// Each feature is expected to declare its own sealed hierarchy that extends
/// [Effect].
abstract class Effect {
  const Effect();
}

/// Convenient no-op effect that can be emitted when no action is required.
class NoopEffect extends Effect {
  const NoopEffect();
}

/// Provides an effect stream that widgets can subscribe to for one-shot UI
/// actions.
mixin EffectEmitter<E extends Effect> implements EffectsProvider<E> {
  final StreamController<E> _effectCtrl = StreamController<E>.broadcast();

  @override
  Stream<E> get effects => _effectCtrl.stream;

  /// Emits a new [effect] if the controller is still active.
  @protected
  void emitEffect(E effect) {
    if (!_effectCtrl.isClosed) _effectCtrl.add(effect);
  }

  /// Disposes the effect controller; call from `close`/`dispose` hooks.
  @mustCallSuper
  void disposeEffects() {
    _effectCtrl.close();
  }
}

/// Implement on an effect to supply analytics metadata directly.
mixin AnalyticsMappableEffect implements Effect {
  String get analyticsEventName; // e.g. 'payment_success'
  Map<String, Object?> get analyticsParameters; // Avoid PII!
}

/// Mapper function used when analytics metadata is provided externally.
typedef AnalyticsEffectMapper<E> = ({String name, Map<String, Object?> params})
    Function(E effect);

/// Expose an analytics service to consumers via dependency injection.
mixin RequiresAnalyticsService {
  @protected
  AnalyticsService get analyticsService;
}

/// Hooks into [emitEffect] to automatically forward analytics events.
mixin AnalyticsEffectEmitter<E extends Effect> on EffectEmitter<E> {
  /// Prefer constructor injection when the owner implements
  /// [RequiresAnalyticsService].
  AnalyticsService? get _injectedService => this is RequiresAnalyticsService
      ? (this as RequiresAnalyticsService).analyticsService
      : null;

  /// Fallback to the global locator if the service is not injected.
  AnalyticsService get _service =>
      _injectedService ?? tpGetIt<AnalyticsService>();

  /// Optional mapper when [AnalyticsMappableEffect] is not implemented.
  @protected
  AnalyticsEffectMapper<E>? get effectMapper => null;

  @override
  @mustCallSuper
  void emitEffect(E effect) {
    super.emitEffect(effect);
    _trackEffect(effect);
  }

  /// Sends analytics information for the emitted [effect].
  Future<void> _trackEffect(E effect) async {
    String name;
    Map<String, Object?> params = const {};

    if (effect is AnalyticsMappableEffect) {
      name = effect.analyticsEventName;
      params = effect.analyticsParameters;
    } else if (effectMapper != null) {
      final mapped = effectMapper!(effect);
      name = mapped.name;
      params = mapped.params;
    } else {
      // Safe fallback: derive the event name from the runtime type.
      name = _snake(effect.runtimeType.toString());
      params = const {};
    }

    // Sanitise to avoid PII and unsupported values.
    params = _sanitize(params);

    // Forward the event through the analytics domain service.
    await _service // ignore: unawaited_futures, analytics call is fire-and-forget.
        .flowResult(flow: 'effect', status: name, extra: params);
    // Alternatively call `logEvent` on your analytics adapter directly.
  }

  Map<String, Object?> _sanitize(Map<String, Object?> m) {
    return m.map((k, v) => MapEntry(_snake(k), _val(v)));
  }

  Object? _val(Object? v) {
    if (v == null || v is num || v is String || v is bool) return v;
    if (v is Iterable) return v.map(_val).toList();
    if (v is Map) return v.map((kk, vv) => MapEntry(_snake(kk), _val(vv)));
    return v.toString();
  }

  String _snake(Object key) {
    final s = key.toString();
    final sb = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final c = s[i];
      final isUpper = c.toUpperCase() == c && c.toLowerCase() != c;
      if (isUpper && i > 0 && s[i - 1] != '_') sb.write('_');
      sb.write(c.toLowerCase());
    }
    final out = sb.toString().replaceAll(RegExp('[^a-z0-9_]+'), '_');
    return RegExp('^[0-9]').hasMatch(out) ? '_$out' : out;
  }
}
