import 'package:flutter/material.dart';

class KanaBackgroundPainter extends CustomPainter {

  final String kana;

  static double lastX = 0;
  static double lastY = 0;
  static double lastWidth = 0;
  static double lastHeight = 0;

  KanaBackgroundPainter(this.kana);

  @override
  void paint(Canvas canvas, Size size) {

    final textPainter = TextPainter(
      text: TextSpan(
        text: kana,
        style: TextStyle(
          fontSize: 220,
          color: Colors.grey.withOpacity(0.12),
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final x =
        (size.width - textPainter.width) / 2;

    final y =
        (size.height - textPainter.height) / 2;

    /// simpan ukuran REAL huruf
    lastX = x;
    lastY = y;
    lastWidth = textPainter.width;
    lastHeight = textPainter.height;

    textPainter.paint(
      canvas,
      Offset(x, y),
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}