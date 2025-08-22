import 'package:flutter/material.dart';
import 'package:inovola_task/core/shared/widgets/circle_rings_painter.dart';

class BalanceBackgroundPainter extends StatelessWidget {
  const BalanceBackgroundPainter({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(50, 50),
      painter: CircleRingsPainter(),
    );
  }
}
