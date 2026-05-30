import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/stroke_model.dart';
import '../../../data/services/stroke_service.dart';
import '../../../widgets/kana_background_painter.dart';

class MenulisController extends GetxController {
  final question = {
    "label": "a",
    "kana": "あ",
    "type": "hiragana",
  };

  final RxList<StrokeData> strokeData = <StrokeData>[].obs;

  final currentStroke = 0.obs;

  final strokeStatus = ''.obs;

  /// stroke permanen
  final List<Offset?> points = [];

  /// stroke sementara
  final List<Offset> tempStroke = [];

  bool isDrawing = false;

  Offset? lastPoint;

  /// canvas ready
  bool canvasReady = false;

  @override
  void onInit() {
    super.onInit();

    loadStroke();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        canvasReady = true;
      });
    });
  }

  /// LOAD JSON
  Future<void> loadStroke() async {
    try {
      final data = await StrokeService.loadStroke(
        question["kana"]!,
        question["type"]!,
      );

      strokeData.assignAll(data);

      update();
    } catch (e) {
      debugPrint("ERROR LOAD STROKE: $e");
    }
  }

  /// TRANSFORM JSON -> CANVAS
  Offset transformPoint(double x, double y) {
    const size = 300.0;

    final width = KanaBackgroundPainter.lastWidth;
    final height = KanaBackgroundPainter.lastHeight;

    if (width == 0 || height == 0) {
      return const Offset(0, 0);
    }

    final sx = width / size;
    final sy = height / size;

    return Offset(
      KanaBackgroundPainter.lastX + (x * sx),
      KanaBackgroundPainter.lastY + (y * sy),
    );
  }

  /// STATUS
  void showStatus(String status) {
    strokeStatus.value = status;

    update();

    Future.delayed(const Duration(milliseconds: 700), () {
      if (strokeStatus.value == status) {
        strokeStatus.value = "";
        update();
      }
    });
  }

  /// HARUS MULAI DARI START POINT JSON
  bool isNearStroke(Offset p, StrokeData stroke) {
    final start = transformPoint(
      stroke.start.x,
      stroke.start.y,
    );

    return (p - start).distance < 70;
  }

  /// START STROKE
  void startStroke(Offset point) {
    if (!canvasReady) return;

    if (currentStroke.value >= strokeData.length) return;

    if (strokeData.isEmpty) return;

    final stroke = strokeData[currentStroke.value];

    if (KanaBackgroundPainter.lastWidth == 0 ||
        KanaBackgroundPainter.lastHeight == 0) {
      return;
    }

    /// wajib mulai dari titik awal yg benar
    if (!isNearStroke(point, stroke)) {
      showStatus("salah");
      return;
    }

    isDrawing = true;

    lastPoint = point;

    tempStroke.clear();

    tempStroke.add(point);

    update();
  }

  /// ADD POINT
  void addPoint(Offset point) {
    if (!isDrawing) return;

    if (lastPoint != null) {
      final dist = (point - lastPoint!).distance;

      /// smooth
      if (dist < 2) return;

      /// cegah teleport ekstrem
      if (dist > 150) {
        isDrawing = false;

        lastPoint = null;

        tempStroke.clear();

        showStatus("salah");

        update();

        return;
      }
    }

    lastPoint = point;

    tempStroke.add(point);

    update();
  }

  /// END STROKE
  void endStroke() {
    if (!isDrawing) return;

    if (lastPoint == null) return;

    final stroke = strokeData[currentStroke.value];

    final start = transformPoint(
      stroke.start.x,
      stroke.start.y,
    );

    final end = transformPoint(
      stroke.end.x,
      stroke.end.y,
    );

    /// =========================
    /// VALIDASI END POINT
    /// =========================
    final endDist = (lastPoint! - end).distance;

    /// =========================
    /// VALIDASI ARAH
    /// =========================
    final userStart = tempStroke.first;
    final userEnd = tempStroke.last;

    final jsonDx = end.dx - start.dx;
    final jsonDy = end.dy - start.dy;

    final userDx = userEnd.dx - userStart.dx;
    final userDy = userEnd.dy - userStart.dy;

    /// dot product
    final dot = (jsonDx * userDx) + (jsonDy * userDy);

    /// panjang vector
    final jsonLength = sqrt((jsonDx * jsonDx) + (jsonDy * jsonDy));

    final userLength = sqrt((userDx * userDx) + (userDy * userDy));

    double similarity = 0;

    if (jsonLength > 0 && userLength > 0) {
      similarity = dot / (jsonLength * userLength);
    }

    /// =========================
    /// VALIDASI FINAL
    /// =========================

    final isDirectionCorrect = similarity > 0.4;

    final isEndCorrect = endDist < 110;

    if (isDirectionCorrect && isEndCorrect) {
      showStatus("benar");

      /// simpan stroke
      points.addAll(tempStroke);

      /// separator
      points.add(null);

      tempStroke.clear();

      currentStroke.value++;
    } else {
      showStatus("salah");

      tempStroke.clear();
    }

    isDrawing = false;

    lastPoint = null;

    update();
  }

  /// CLEAR
  void clearCanvas() {
    points.clear();

    tempStroke.clear();

    currentStroke.value = 0;

    isDrawing = false;

    lastPoint = null;

    strokeStatus.value = "";

    update();
  }

  /// UNDO
  void undo() {
    if (points.isEmpty) return;

    isDrawing = false;

    lastPoint = null;

    tempStroke.clear();

    strokeStatus.value = "";

    /// hapus separator null
    while (points.isNotEmpty && points.last == null) {
      points.removeLast();
    }

    /// hapus 1 stroke terakhir
    while (points.isNotEmpty && points.last != null) {
      points.removeLast();
    }

    /// balik stroke
    if (currentStroke.value > 0) {
      currentStroke.value--;
    }

    update();
  }
}