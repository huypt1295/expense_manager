import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_common/src/utils/log_utils.dart';

import 'disposable.dart';

class DisposeBag {
  final List<Object> _disposable = [];

  void addDisposable(Object disposable) {
    _disposable.add(disposable);
  }

  void dispose() {
    for (var disposable in _disposable) {
      if (disposable is StreamSubscription) {
        disposable.cancel();
        Log.d('Canceled $disposable');
      } else if (disposable is StreamController) {
        disposable.close();
        Log.d('Closed $disposable');
      } else if (disposable is ChangeNotifier) {
        disposable.dispose();
        Log.d('Disposed $disposable');
      } else if (disposable is Disposable) {
        disposable.dispose();
      }
    }

    _disposable.clear();
  }
}

extension StreamSubscriptionExtensions<T> on StreamSubscription<T> {
  void disposeBy(DisposeBag disposeBag) {
    disposeBag.addDisposable(this);
  }
}

extension StreamControllerExtensions<T> on StreamController<T> {
  void disposeBy(DisposeBag disposeBag) {
    disposeBag.addDisposable(this);
  }
}

extension ChangeNotifierExtensions on ChangeNotifier {
  void disposeBy(DisposeBag disposeBag) {
    disposeBag.addDisposable(this);
  }
}

extension DisposableExtensions on Disposable {
  void disposeBy(DisposeBag disposeBag) {
    disposeBag.addDisposable(this);
  }
}
