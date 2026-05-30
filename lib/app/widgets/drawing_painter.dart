import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter {

  final List<Offset?> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {

    final paintLine = Paint()
      ..color = Colors.black
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {

      final p1 = points[i];
      final p2 = points[i + 1];

      if (p1 != null && p2 != null) {

        canvas.drawLine(
          p1,
          p2,
          paintLine,
        );
      }
    }
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return true;
  }
}