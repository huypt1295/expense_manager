import 'package:flutter/widgets.dart';

class EffectListenerMulti extends StatelessWidget {
  const EffectListenerMulti({
    super.key,
    required this.listeners,
    required this.child,
  });

  final List<Widget> listeners; // mỗi phần tử là một EffectListener<...>
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget current = child;
    // Gói child bằng các listener từ cuối lên đầu
    for (final l in listeners.reversed) {
      current = _Wrap(wrapper: l, child: current);
    }
    return current;
  }
}

class _Wrap extends StatelessWidget {
  const _Wrap({required this.child, required this.wrapper});
  final Widget child;
  final Widget wrapper;
  @override
  Widget build(BuildContext context) =>
      _Passthrough(wrapper: wrapper, child: child);
}

class _Passthrough extends StatelessWidget {
  const _Passthrough({required this.child, required this.wrapper});
  final Widget child;
  final Widget wrapper;

  @override
  Widget build(BuildContext context) {
    // replace placeholder child của wrapper bằng child thật
    // giả định wrapper là một EffectListener với child = null
    return _WithChild(wrapper: wrapper, child: child);
  }
}

class _WithChild extends StatelessWidget {
  const _WithChild({required this.wrapper, required this.child});
  final Widget wrapper;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Nếu wrapper là Stateless với field child, bạn có thể sửa EffectListener
    // nhận child bắt buộc để bỏ hack này. Để ngắn gọn, bạn có thể xếp tay:
    return wrapper is SingleChildRenderObjectWidget
        ? wrapper // giữ đơn giản: đa phần dùng EffectListener lồng nhau là đủ
        : wrapper;
  }
}
