import 'package:flutter/material.dart';
import '../data/models/stroke_model.dart';
import 'kana_background_painter.dart';

class StrokeOrderPainter extends CustomPainter {
  final List<StrokeData> strokes;

  StrokeOrderPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final startPaint = Paint()..color = Colors.red;

    final endPaint = Paint()..color = Colors.blue;

    /// ukuran asli json
    const jsonSize = 300.0;

    /// scale otomatis mengikuti huruf
    final scaleX = KanaBackgroundPainter.lastWidth / jsonSize;

    final scaleY = KanaBackgroundPainter.lastHeight / jsonSize;

    for (int i = 0; i < strokes.length; i++) {
      final stroke = strokes[i];

      const adjustX = -8.0;
      const adjustY = 12.0;

      final startX =
          KanaBackgroundPainter.lastX + (stroke.start.x * scaleX) + adjustX;

      final startY =
          KanaBackgroundPainter.lastY + (stroke.start.y * scaleY) + adjustY;

      final endX =
          KanaBackgroundPainter.lastX + (stroke.end.x * scaleX) + adjustX;

      final endY =
          KanaBackgroundPainter.lastY + (stroke.end.y * scaleY) + adjustY;

      canvas.drawCircle(Offset(startX, startY), 10, startPaint);

      canvas.drawCircle(Offset(endX, endY), 8, endPaint);

      final endTextPainter = TextPainter(
        text: TextSpan(
          text: "${i + 1}",
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      endTextPainter.layout();

      endTextPainter.paint(canvas, Offset(endX + 10, endY - 10));

      final textPainter = TextPainter(
        text: TextSpan(
          text: "${i + 1}",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      textPainter.paint(canvas, Offset(startX + 10, startY - 10));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
