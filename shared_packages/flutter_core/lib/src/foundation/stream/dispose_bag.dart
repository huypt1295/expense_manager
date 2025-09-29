import 'dart:async';

import 'package:flutter/material.dart';
import 'disposable_base.dart';

/// Collects disposable resources and releases them in a single call.
class DisposeBag {
  final List<Object> _disposable = [];

  /// Adds a disposable resource to the bag.
  void addDisposable(Object disposable) {
    _disposable.add(disposable);
  }

  /// Cancels, closes, or disposes of every tracked resource.
  void dispose() {
    for (var disposable in _disposable) {
      if (disposable is StreamSubscription) {
        disposable.cancel();
      } else if (disposable is StreamController) {
        disposable.close();
      } else if (disposable is ChangeNotifier) {
        disposable.dispose();
      } else if (disposable is DisposableBase) {
        disposable.dispose();
      }
    }

    _disposable.clear();
  }
}

/// Allows a [StreamSubscription] to register itself with a [DisposeBag].
extension StreamSubscriptionExtensions<T> on StreamSubscription<T> {
  /// Adds this subscription to [disposeBag] for automatic cancellation.
  void disposeBy(DisposeBag disposeBag) {
    disposeBag.addDisposable(this);
  }
}

/// Allows a [StreamController] to register itself with a [DisposeBag].
extension StreamControllerExtensions<T> on StreamController<T> {
  /// Adds this controller to [disposeBag] for automatic closing.
  void disposeBy(DisposeBag disposeBag) {
    disposeBag.addDisposable(this);
  }
}

/// Allows a [ChangeNotifier] to register itself with a [DisposeBag].
extension ChangeNotifierExtensions on ChangeNotifier {
  /// Adds this notifier to [disposeBag] for automatic disposal.
  void disposeBy(DisposeBag disposeBag) {
    disposeBag.addDisposable(this);
  }
}

/// Allows any [DisposableBase] to register itself with a [DisposeBag].
extension DisposableExtensions on DisposableBase {
  /// Adds this disposable to [disposeBag] for automatic teardown.
  void disposeBy(DisposeBag disposeBag) {
    disposeBag.addDisposable(this);
  }
}
