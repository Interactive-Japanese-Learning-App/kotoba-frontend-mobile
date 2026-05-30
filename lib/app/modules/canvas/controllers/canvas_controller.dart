import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotoba_app/app/widgets/kana_background_painter.dart';
import '../../../data/models/stroke_model.dart';
import '../../../data/services/stroke_service.dart';
import 'dart:math';

class CanvasController extends GetxController {
  final List<Offset?> points = [];
  List<Offset> currentStrokePoints = [];

  final RxList<StrokeData> strokeData = <StrokeData>[].obs;

  final currentStroke = 0.obs;
  final strokeStatus = ''.obs;

  bool isDrawing = false;
  bool strokeLocked = false;

  Offset? lastPoint;

  final label = ''.obs;
  final kana = ''.obs;
  final type = ''.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};

    label.value = args['label'] ?? '';
    kana.value = args['kana'] ?? '';
    type.value = args['type'] ?? '';

    loadStrokeJson();
  }

  Future<void> loadStrokeJson() async {
    final data = await StrokeService.loadStroke(
      kana.value,
      type.value.toLowerCase(),
    );

    strokeData.assignAll(data);
    update();
  }

  Offset transformPoint(double x, double y) {
    const jsonSize = 300.0;

    final scaleX = KanaBackgroundPainter.lastWidth / jsonSize;
    final scaleY = KanaBackgroundPainter.lastHeight / jsonSize;

    const adjustX = -8.0;
    const adjustY = 12.0;

    return Offset(
      KanaBackgroundPainter.lastX + (x * scaleX) + adjustX,
      KanaBackgroundPainter.lastY + (y * scaleY) + adjustY,
    );
  }

  void startStroke(Offset point) {
    if (strokeLocked) return;
    if (currentStroke.value >= strokeData.length) return;

    isDrawing = true;
    lastPoint = point;
    currentStrokePoints = [point];
    update();
  }

  void addPoint(Offset point) {
    if (!isDrawing || strokeLocked) return;

    if (lastPoint != null) {
      final dist = (point - lastPoint!).distance;
      if (dist > 80) {
        isDrawing = false;
        strokeStatus.value = "salah";
        currentStrokePoints.clear();
        _resetStatus();
        return;
      }
      if (dist < 2) return;
    }

    lastPoint = point;
    currentStrokePoints.add(point);
    update();
  }

  void endStrokeCheck() {
    if (!isDrawing) return;

    isDrawing = false;

    final target = strokeData[currentStroke.value];
    final end = transformPoint(target.end.x, target.end.y);

    final dist = (lastPoint! - end).distance;
    const tolerance = 35.0;

    if (dist < tolerance) {
      strokeStatus.value = "benar";

      points.addAll(currentStrokePoints);
      points.add(null);

      currentStrokePoints = [];
      currentStroke.value++;

      _resetStatus();
    } else {
      strokeStatus.value = "salah";
      currentStrokePoints.clear();
      _resetStatus();
    }

    lastPoint = null;
    update();
  }

  // ❗ TIDAK AUTO EXIT LAGI
  bool isCompleted() {
    return currentStroke.value >= strokeData.length;
  }

  void _resetStatus() {
    strokeLocked = true;

    Future.delayed(const Duration(milliseconds: 1200), () {
      strokeStatus.value = "";
      strokeLocked = false;
      update();
    });
  }

  void clearCanvas() {
    points.clear();
    currentStrokePoints.clear();
    currentStroke.value = 0;

    isDrawing = false;
    strokeLocked = false;
    lastPoint = null;
    strokeStatus.value = "";

    update();
  }

  void undo() {
    if (points.isEmpty) return;

    isDrawing = false;
    strokeLocked = false;
    lastPoint = null;
    strokeStatus.value = "";

    if (points.last == null) {
      points.removeLast();
    }

    while (points.isNotEmpty && points.last != null) {
      points.removeLast();
    }

    if (currentStroke.value > 0) {
      currentStroke.value--;
    }

    update();
  }
}