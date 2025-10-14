import 'dart:ui';

class ChartSlice {
  const ChartSlice({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final double amount;
  final Color color;
}