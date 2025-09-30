import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_core/src/foundation/stream/disposable_base.dart';
import 'package:flutter_core/src/foundation/stream/dispose_bag.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeStreamSubscription<T> implements StreamSubscription<T> {
  bool cancelled = false;
  bool paused = false;

  @override
  bool get isPaused => paused;

  @override
  Future<void> cancel() async {
    cancelled = true;
  }

  @override
  Future<E> asFuture<E>([E? futureValue]) =>
      Future<E>.error(UnimplementedError());

  @override
  void onData(void Function(T data)? handleData) {}

  @override
  void onDone(void Function()? handleDone) {}

  @override
  void onError(Function? handleError) {}

  @override
  void pause([Future<void>? resumeSignal]) {
    paused = true;
  }

  @override
  void resume() {
    paused = false;
  }
}

class _TestNotifier extends ChangeNotifier {
  bool disposed = false;

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}

class _FakeDisposable extends DisposableBase {
  bool disposed = false;

  @override
  void dispose() {
    disposed = true;
  }
}

void main() {
  group('DisposeBag', () {
    late DisposeBag bag;

    setUp(() {
      bag = DisposeBag();
    });

    test('disposes registered resources', () {
      final subscription = _FakeStreamSubscription<int>();
      final controller = StreamController<int>();
      final notifier = _TestNotifier();
      final disposable = _FakeDisposable();

      bag.addDisposable(subscription);
      bag.addDisposable(controller);
      bag.addDisposable(notifier);
      bag.addDisposable(disposable);

      bag.dispose();

      expect(subscription.cancelled, isTrue);
      expect(controller.isClosed, isTrue);
      expect(notifier.disposed, isTrue);
      expect(disposable.disposed, isTrue);
    });

    test('extensions enroll resources into bag', () {
      final subscription = _FakeStreamSubscription<int>();
      final controller = StreamController<int>();
      final notifier = _TestNotifier();
      final disposable = _FakeDisposable();

      subscription.disposeBy(bag);
      controller.disposeBy(bag);
      notifier.disposeBy(bag);
      disposable.disposeBy(bag);

      bag.dispose();

      expect(subscription.cancelled, isTrue);
      expect(controller.isClosed, isTrue);
      expect(notifier.disposed, isTrue);
      expect(disposable.disposed, isTrue);
    });

    test('dispose can be called multiple times safely', () {
      final subscription = _FakeStreamSubscription<int>();
      bag.addDisposable(subscription);

      bag.dispose();
      expect(subscription.cancelled, isTrue);

      // Should not throw or change state when invoked again.
      bag.dispose();
      expect(subscription.cancelled, isTrue);
    });
  });
}
