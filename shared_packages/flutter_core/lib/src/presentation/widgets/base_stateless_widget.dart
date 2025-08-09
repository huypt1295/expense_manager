import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

/// Base class for stateless widgets providing common hooks and utilities.
///
/// Responsibilities:
/// - Convenience methods: `showLoading`, `hideLoading` via EasyLoading (exported in flutter_core).
/// - `onPostBuild` callback scheduled after the first frame to run one-off side effects.
abstract class BaseStatelessWidget extends StatelessWidget {
  const BaseStatelessWidget({super.key});

  /// Hook called once after the first frame of this widget is built.
  /// Useful for navigation, snackbars, or calling bloc events.
  @protected
  void onPostBuild(BuildContext context) {}

  /// Shows a global loading indicator.
  @protected
  void showLoading() {
    EasyLoading.show();
  }

  /// Hides the global loading indicator.
  @protected
  void hideLoading({bool animation = true}) {
    EasyLoading.dismiss(animation: animation);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        onPostBuild(context);
      }
    });
    return buildContent(context);
  }

  /// Implement UI here instead of overriding `build`.
  @protected
  Widget buildContent(BuildContext context);
}
