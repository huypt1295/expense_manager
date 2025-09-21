import 'package:flutter/material.dart';

/// Thực thi hành động UI *ngay lập tức* nếu State còn mounted.
/// Không expose BuildContext ra ngoài.
class UiActions {
  UiActions(this._state);
  final State _state;

  bool get mounted => _state.mounted;

  /// Thực thi một action đồng bộ sử dụng context an toàn.
  /// YÊU CẦU: [action] phải là SYNC (không await bên trong).
  void call(void Function(BuildContext ctx) action) {
    if (!_state.mounted) return;
    action(_state.context);
  }

  /// SnackBar helper
  void showSnackBar(SnackBar bar) {
    if (!_state.mounted) return;
    ScaffoldMessenger.of(_state.context).showSnackBar(bar);
  }

  /// Dialog helper (vẫn an toàn vì context chỉ dùng tại thời điểm gọi)
  Future<T?> showDialogSafe<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) {
    if (!_state.mounted) return Future<T?>.value(null);
    return showDialog<T>(
      context: _state.context,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
  }

  /// Navigator helpers (tuỳ app dùng Navigator hay go_router, truyền closure sync)
  void navigate(void Function(BuildContext ctx) go) {
    if (!_state.mounted) return;
    go(_state.context); // ví dụ: (ctx) => context.push('/route')
  }

  void maybePop() {
    if (!_state.mounted) return;
    Navigator.of(_state.context).maybePop();
  }
}
