import 'dart:async';

import 'package:flutter_core/src/domain/analytics/analytics_service.dart';
import 'package:flutter_core/src/presentation/bloc/effect/effect.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestEffect extends Effect {
  const _TestEffect(this.label);
  final String label;
}

class _AnalyticsReadyEffect extends _TestEffect with AnalyticsMappableEffect {
  const _AnalyticsReadyEffect(String name, Map<String, Object?> params)
    : _eventName = name,
      _params = params,
      super('analytics:$name');

  final String _eventName;
  final Map<String, Object?> _params;

  @override
  String get analyticsEventName => _eventName;

  @override
  Map<String, Object?> get analyticsParameters => _params;
}

class _FakeAnalyticsService implements AnalyticsService {
  final List<(String flow, String status, Map<String, Object?> extra)>
  flowEvents = [];

  @override
  Future<void> appOpen({String? source}) async {}

  @override
  Future<void> screenView(String screenName, {String? screenClass}) async {}

  @override
  Future<void> login({required String method, String? userId}) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<void> flowStart({
    required String flow,
    Map<String, Object?> extra = const {},
  }) async {}

  @override
  Future<void> flowResult({
    required String flow,
    required String status,
    Map<String, Object?> extra = const {},
  }) async {
    flowEvents.add((flow, status, extra));
  }

  @override
  Future<void> purchase({
    required String transactionId,
    required String currency,
    required num value,
    required List<GAItem> items,
    num? tax,
    num? shipping,
    String? coupon,
    String? paymentMethod,
  }) async {}

  @override
  Future<void> refund({
    required String transactionId,
    required String currency,
    num? value,
    List<GAItem>? items,
    String? reason,
  }) async {}

  @override
  Future<void> chargeback({
    required String transactionId,
    required String currency,
    required num value,
    String? reason,
    String? network,
  }) async {}
}

class _BareEmitter with EffectEmitter<_TestEffect> {
  void send(_TestEffect effect) => emitEffect(effect);
}

class _AnalyticsEmitter
    with
        EffectEmitter<_TestEffect>,
        AnalyticsEffectEmitter<_TestEffect>,
        RequiresAnalyticsService {
  _AnalyticsEmitter(this._service);

  final _FakeAnalyticsService _service;
  AnalyticsEffectMapper<_TestEffect>? mapper;

  @override
  AnalyticsService get analyticsService => _service;

  @override
  AnalyticsEffectMapper<_TestEffect>? get effectMapper => mapper;

  void send(_TestEffect effect) => emitEffect(effect);
}

void main() {
  test('EffectEmitter emits values and stops after dispose', () async {
    final emitter = _BareEmitter();
    final collected = <String>[];
    final sub = emitter.effects.listen((effect) => collected.add(effect.label));

    emitter.send(const _TestEffect('first'));
    await Future<void>.delayed(Duration.zero);

    expect(collected, ['first']);

    emitter.disposeEffects();
    emitter.send(const _TestEffect('second'));
    await Future<void>.delayed(Duration.zero);

    expect(collected, ['first']);
    await sub.cancel();
  });

  group('AnalyticsEffectEmitter', () {
    late _FakeAnalyticsService service;
    late _AnalyticsEmitter emitter;
    late StreamSubscription<_TestEffect> sub;
    final emittedEffects = <_TestEffect>[];

    setUp(() {
      service = _FakeAnalyticsService();
      emitter = _AnalyticsEmitter(service);
      sub = emitter.effects.listen(emittedEffects.add);
    });

    tearDown(() async {
      await sub.cancel();
      emitter.disposeEffects();
      emittedEffects.clear();
    });

    test('uses analytics metadata provided by effect', () async {
      emitter.send(
        const _AnalyticsReadyEffect('SubmitFlow', {
          'Attempt Count': 2,
          'Details': {'User ID': 10},
        }),
      );

      await Future<void>.delayed(Duration.zero);

      expect(emittedEffects.single.label, 'analytics:SubmitFlow');
      expect(service.flowEvents.single.$2, 'SubmitFlow');
      expect(service.flowEvents.single.$3, {
        'attempt__count': 2,
        'details': {'user__i_d': 10},
      });
    });

    test(
      'uses mapper when effect does not implement AnalyticsMappableEffect',
      () async {
        emitter.mapper = (effect) =>
            (name: 'custom_event', params: {'Label': effect.label});

        emitter.send(const _TestEffect('Go'));
        await Future<void>.delayed(Duration.zero);

        final event = service.flowEvents.single;
        expect(event.$2, 'custom_event');
        expect(event.$3, {'label': 'Go'});
      },
    );

    test('falls back to runtime type when no mapper provided', () async {
      emitter.send(const _TestEffect('Any'));
      await Future<void>.delayed(Duration.zero);

      final event = service.flowEvents.single;
      expect(event.$2, '_test_effect');
      expect(event.$3, const {});
    });
  });
}
