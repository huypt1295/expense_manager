import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_core/src/foundation/stream/dispose_bag.dart'
    show DisposeBag;

/// Base class for stateful widgets providing common lifecycle hooks and utilities.
///
/// Responsibilities:
/// - Provides a `DisposeBag` for subscriptions/controllers.
/// - Standard lifecycle hooks: `onInitState`, `onDependenciesChanged`,
///   `onPostFrame`, `onDeactivate`, `onDispose`.
/// - Convenience loading methods: `showLoading`, `hideLoading`.
abstract class BaseStatefulWidget extends StatefulWidget {
  const BaseStatefulWidget({super.key});
}

/// Shared base [State] that exposes lifecycle hooks and a [DisposeBag].
abstract class BaseState<T extends BaseStatefulWidget> extends State<T> {
  final DisposeBag disposeBag = DisposeBag();

  /// Called in `initState` before `onPostFrame`.
  @protected
  void onInitState() {}

  /// Called when dependencies change (e.g., InheritedWidget updates).
  @protected
  void onDependenciesChanged() {}

  /// Called after the first frame is rendered. Good for navigation, dialogs.
  @protected
  void onPostFrame() {}

  /// Called on `deactivate`.
  @protected
  void onDeactivate() {}

  /// Called in `dispose` before cleaning up the `DisposeBag`.
  @protected
  void onDispose() {}

  @protected
  void showLoading() {
    EasyLoading.show();
  }

  @protected
  void hideLoading({bool animation = true}) {
    EasyLoading.dismiss(animation: animation);
  }

  @override
  void initState() {
    super.initState();
    onInitState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) onPostFrame();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    onDependenciesChanged();
  }

  @override
  void deactivate() {
    super.deactivate();
    onDeactivate();
  }

  @override
  void dispose() {
    onDispose();
    disposeBag.dispose();
    super.dispose();
  }
}
