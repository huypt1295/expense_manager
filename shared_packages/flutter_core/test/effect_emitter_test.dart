import 'package:flutter_core/src/presentation/bloc/effect/effect.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestEffect extends Effect {
  const _TestEffect(this.value);
  final String value;
}

class _EffectOwner with EffectEmitter<_TestEffect> {}

void main() {
  test('EffectEmitter broadcasts emitted effects', () async {
    final owner = _EffectOwner();
    final received = <String>[];
    final sub = owner.effects.listen((e) => received.add(e.value));

    // ignore: invalid_use_of_protected_member
    owner.emitEffect(const _TestEffect('first'));
    // ignore: invalid_use_of_protected_member
    owner.emitEffect(const _TestEffect('second'));

    await Future<void>.delayed(Duration.zero);
    expect(received, ['first', 'second']);

    await sub.cancel();
    owner.disposeEffects();

    // No further events dispatched after dispose.
    // ignore: invalid_use_of_protected_member
    owner.emitEffect(const _TestEffect('ignored'));
    await Future<void>.delayed(Duration.zero);
    expect(received, ['first', 'second']);
  });
}
