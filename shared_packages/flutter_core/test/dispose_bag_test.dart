import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_core/src/foundation/stream/dispose_bag.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestNotifier extends ChangeNotifier {
  bool disposed = false;
  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}

void main() {
  test('dispose cancels all tracked resources', () async {
    var cancelled = false;
    final bag = DisposeBag();
    final controller = StreamController<int>(onCancel: () {
      cancelled = true;
    });
    final subscription = controller.stream.listen((_) {});
    final notifier = _TestNotifier();

    controller.disposeBy(bag);
    subscription.disposeBy(bag);
    notifier.disposeBy(bag);

    bag.dispose();

    expect(controller.isClosed, isTrue);
    expect(cancelled, isTrue);
    expect(() => controller.add(1), throwsA(isA<StateError>()));
    expect(notifier.disposed, isTrue);
  });
}
