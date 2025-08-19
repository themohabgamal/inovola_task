import 'dart:math';
import 'package:flutter/material.dart';

class CircleRingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final List<double> radii = [120, 60, 40];
    final double spacing = 130;
    final double angle = -34 * (pi / 180);

    double startX = size.width * 0.3;
    double startY = size.height * 0.8;

    for (int i = 0; i < radii.length; i++) {
      final double opacity = 0.10 - (i * 0.01);

      // Circle position
      double x = startX + (spacing * i * cos(angle));
      double y = startY + (spacing * i * sin(angle));
      final center = Offset(x, y);

      // Use a SweepGradient to fade top and bottom
      final shader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * pi,
        colors: [
          Colors.white.withValues(alpha: opacity),
          Colors.transparent,
          Colors.white.withValues(alpha: opacity),
          Colors.white.withValues(alpha: 0.02),
          Colors.white.withValues(alpha: opacity),
        ],
        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radii[i]));

      final paint = Paint()
        ..shader = shader
        ..style = PaintingStyle.stroke
        ..strokeWidth = 19.0;
      canvas.drawCircle(center, radii[i], paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
