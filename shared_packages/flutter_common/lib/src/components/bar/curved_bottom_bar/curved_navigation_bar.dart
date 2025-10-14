import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_resource/flutter_resource.dart' show TPTextStyle;

import 'nav_button.dart';
import 'nav_custom_clipper.dart';
import 'nav_custom_painter.dart';

class CurvedNavigationBar extends StatefulWidget {
  final List<CurvedNavigationItem> items;
  final int selectedIndex;
  final int curvedIndex;
  final Color color;
  final Color curvedBackgroundColor;
  final Color backgroundColor;
  final ValueChanged<int>? onTap;
  final double height;
  final double? maxWidth;

  CurvedNavigationBar({
    super.key,
    required this.items,
    this.selectedIndex = 0,
    this.curvedIndex = 0,
    this.color = Colors.white,
    required this.curvedBackgroundColor,
    this.backgroundColor = Colors.blueAccent,
    this.onTap,
    this.height = 75.0,
    this.maxWidth,
  }) : assert(items.isNotEmpty),
       assert(0 <= selectedIndex && selectedIndex < items.length),
       assert(0 <= height && height <= 75.0),
       assert(maxWidth == null || 0 <= maxWidth);

  @override
  CurvedNavigationBarState createState() => CurvedNavigationBarState();
}

class CurvedNavigationBarState extends State<CurvedNavigationBar>
    with SingleTickerProviderStateMixin {
  late double _pos;
  late AnimationController _animationController;
  late int _length;

  @override
  void initState() {
    super.initState();
    _length = widget.items.length;
    _pos = widget.curvedIndex / _length;
    _animationController = AnimationController(vsync: this, value: _pos);
    final curvedPosition = widget.curvedIndex / _length;
    _animationController.animateTo(
      curvedPosition,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = min(
            constraints.maxWidth,
            widget.maxWidth ?? constraints.maxWidth,
          );
          return Align(
            alignment: textDirection == TextDirection.ltr
                ? Alignment.bottomLeft
                : Alignment.bottomRight,
            child: Container(
              color: widget.backgroundColor,
              width: maxWidth,
              child: ClipRect(
                clipper: NavCustomClipper(
                  deviceHeight: MediaQuery.sizeOf(context).height,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    _buildCurvedIcon(textDirection, maxWidth),
                    _buildNavCurvedBackground(textDirection),
                    _buildNavIcons(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurvedIcon(TextDirection textDirection, double maxWidth) {
    final IconData icon = widget.items[widget.curvedIndex].icon;
    return Positioned(
      bottom: -40 - (75.0 - widget.height),
      left: textDirection == TextDirection.rtl ? null : _pos * maxWidth,
      right: textDirection == TextDirection.rtl ? _pos * maxWidth : null,
      width: maxWidth / _length,
      child: Center(
        child: Transform.translate(
          offset: Offset(0, -80),
          child: Material(
            color: widget.curvedBackgroundColor,
            type: MaterialType.circle,
            child: Material(
              elevation: 4,
              shadowColor: Colors.blue.withOpacity(0.5),
              shape: CircleBorder(),
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(icon, color: context.tpColors.iconReverse),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavCurvedBackground(TextDirection textDirection) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0 - (75.0 - widget.height),
      child: CustomPaint(
        painter: NavCustomPainter(_pos, _length, widget.color, textDirection),
        child: Container(height: 80.0),
      ),
    );
  }

  Widget _buildNavIcons() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0 - (75.0 - widget.height),
      child: SizedBox(
        height: 100.0,
        child: Row(
          children: widget.items.map((item) {
            return NavButton(
              onTap: _buttonTap,
              position: _pos,
              length: _length,
              index: widget.items.indexOf(item),
              child: Center(
                child: CurvedNavigationItemWidget(
                  item: item,
                  color: widget.items.indexOf(item) == widget.selectedIndex
                      ? context.tpColors.iconNeutral
                      : context.tpColors.iconSub,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void setPage(int index) {
    _buttonTap(index);
  }

  void _buttonTap(int index) {
    if (_animationController.isAnimating) {
      return;
    }
    if (widget.onTap != null) {
      widget.onTap!(index);
    }
  }
}

class CurvedNavigationItem {
  final IconData icon;
  final String label;

  const CurvedNavigationItem({required this.icon, required this.label});
}

class CurvedNavigationItemWidget extends StatelessWidget {
  final CurvedNavigationItem item;
  final Color color;

  const CurvedNavigationItemWidget({
    super.key,
    required this.item,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(item.icon, color: color),
        Text(item.label, style: TPTextStyle.itemNameS.copyWith(color: color)),
      ],
    );
  }
}
