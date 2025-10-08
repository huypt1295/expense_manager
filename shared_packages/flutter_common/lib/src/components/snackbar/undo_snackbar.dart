import 'dart:math' as math;

import 'package:flutter/material.dart';

class UndoSnackBarContent extends StatefulWidget {
  const UndoSnackBarContent({
    super.key,
    required this.message,
    required this.label,
    required this.duration,
    required this.onUndo,
  });

  final String message;
  final String label;
  final Duration duration;
  final VoidCallback onUndo;

  @override
  State<UndoSnackBarContent> createState() => _UndoSnackBarContentState();
}

class _UndoSnackBarContentState extends State<UndoSnackBarContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _didUndo = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleUndo() {
    if (_didUndo) return;
    _didUndo = true;
    widget.onUndo();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Text(widget.message)),
        const SizedBox(width: 16),
        _UndoCircleButton(
          animation: _controller,
          label: widget.label,
          onPressed: _handleUndo,
        ),
      ],
    );
  }
}

class _UndoCircleButton extends StatelessWidget {
  const _UndoCircleButton({
    required this.animation,
    required this.label,
    required this.onPressed,
  });

  final Animation<double> animation;
  final String label;
  final VoidCallback onPressed;

  static const double _diameter = 40;
  static const double _strokeWidth = 2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final progress = animation.value.clamp(0.0, 1.0);
        final isActive = progress < 1.0;

        return SizedBox(
          width: _diameter,
          height: _diameter,
          child: IgnorePointer(
            ignoring: !isActive,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  painter: _CountdownCirclePainter(
                    color: colors.primary,
                    progress: progress,
                    strokeWidth: _strokeWidth,
                  ),
                  child: const SizedBox.expand(),
                ),
                Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: isActive ? onPressed : null,
                    customBorder: const CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        label,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CountdownCirclePainter extends CustomPainter {
  _CountdownCirclePainter({
    required this.color,
    required this.progress,
    required this.strokeWidth,
  });

  final Color color;
  final double progress;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final remaining = (1 - progress).clamp(0.0, 1.0);
    if (remaining <= 0) {
      return;
    }

    final sweepAngle = remaining * 2 * math.pi;
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(strokeWidth / 2);

    canvas.drawArc(arcRect, -math.pi / 2, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant _CountdownCirclePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
