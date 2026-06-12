import 'package:flutter/material.dart';
import 'kana_background_painter.dart' as text_bg;

class KanaImageBackgroundPainter extends CustomPainter {
  final String assetPath;

  final double opacity;
  static const double jsonSize = 300.0;

  final BoxFit fit;
  KanaImageBackgroundPainter({
    required this.assetPath,
    this.opacity = 0.12,
    this.fit = BoxFit.contain,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fitted = _computeFitRect(
      srcSize: const Size(jsonSize, jsonSize),
      dstSize: size,
      fit: fit,
    );

    // Update static fields supaya painter lain & controller tetap align.
    text_bg.KanaBackgroundPainter.lastX = fitted.left;
    text_bg.KanaBackgroundPainter.lastY = fitted.top;
    text_bg.KanaBackgroundPainter.lastWidth = fitted.width;
    text_bg.KanaBackgroundPainter.lastHeight = fitted.height;
  }

  Rect _computeFitRect({
    required Size srcSize,
    required Size dstSize,
    required BoxFit fit,
  }) {
    final srcW = srcSize.width;
    final srcH = srcSize.height;
    final dstW = dstSize.width;
    final dstH = dstSize.height;

    if (srcW == 0 || srcH == 0) {
      return Rect.fromLTWH(0, 0, dstW, dstH);
    }

    switch (fit) {
      case BoxFit.fill:
        return Rect.fromLTWH(0, 0, dstW, dstH);
      case BoxFit.contain:
        final scale = (dstW / srcW).clamp(0, double.infinity);
        final scaleH = dstH / srcH;
        final s = scale < scaleH ? scale : scaleH;
        final w = srcW * s;
        final h = srcH * s;
        final left = (dstW - w) / 2;
        final top = (dstH - h) / 2;
        return Rect.fromLTWH(left, top, w, h);
      case BoxFit.cover:
        final scale = (dstW / srcW).clamp(0, double.infinity);
        final scaleH = dstH / srcH;
        final s = scale > scaleH ? scale : scaleH;
        final w = srcW * s;
        final h = srcH * s;
        final left = (dstW - w) / 2;
        final top = (dstH - h) / 2;
        return Rect.fromLTWH(left, top, w, h);
      default:
        return Rect.fromLTWH(0, 0, dstW, dstH);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


