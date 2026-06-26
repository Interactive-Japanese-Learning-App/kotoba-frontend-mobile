import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/models/stroke_model.dart';
import '../../../data/services/stroke_service.dart';
import '../../../widgets/kana_background_painter.dart';
import '../../../data/services/api_service.dart';
import '../quiz/quiz_controller.dart';

class MenulisController extends GetxController {
  // Reactive States untuk MongoDB
  final isLoading = true.obs;

  final isAllStrokesDone = false.obs;
  final isOcrProcessing = false.obs;
  final isAnswered = false.obs;
  final question = Rxn<Map<String, dynamic>>();
  final RxList<StrokeData> strokeData = <StrokeData>[].obs;

  // State Goresan/Stroke Kanvas Asli
  final currentStroke = 0.obs;
  final strokeStatus = ''.obs;
  final List<Offset?> points = [];
  final List<Offset> tempStroke = [];
  final box = GetStorage();

  String? get userId => box.read('userId');

  bool isDrawing = false;
  bool canvasReady = false;
  Offset? lastPoint;

  // Route Arguments Penampung ID MongoDB
  late String sectionId;
  late String sectionTitle;
  late int questionNo;

  @override
  void onInit() {
    super.onInit();
    print("ARGUMENTS = ${Get.arguments}");

    final args = Get.arguments ?? {};
    sectionId = args["sectionId"] ?? "";
    sectionTitle = args["sectionTitle"] ?? "";

    if (sectionId.isNotEmpty) {
      loadQuestionData();
    } else {
      canvasReady = true;
      loadStroke();
      isLoading.value = false;
    }
  }

  // Mengambil data pertanyaan menulis dari database MongoDB
  Future<void> loadQuestionData() async {
    try {
      isLoading.value = true;

      print("SECTION ID = $sectionId");

      final response = await ApiService.getQuizQuestions(sectionId);

      print("RESPONSE = $response");

      if (response["success"] == true) {
        final questions = response["data"] as List;

        print("QUESTIONS = $questions");

        final found = questions.where((e) => e["questionNo"] == 4);

        print("FOUND = ${found.toList()}");

        if (found.isNotEmpty) {
          question.value = found.first;
          questionNo = found.first["questionNo"];
          await loadStroke();
          canvasReady = true;
          print("QUESTION = ${question.value}");
        }
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Mengambil pola stroke berdasarkan huruf Kana
  Future<void> loadStroke() async {
    try {
      if (question.value?["kana"] == null) return;

      final data = await StrokeService.loadStroke(
        question.value!["kana"].toString(),
        "hiragana",
      );

      strokeData.assignAll(data);
      update();
    } catch (e) {
      debugPrint("ERROR LOAD STROKE : $e");
    }
  }

  // Pengiriman progress jawaban ke API MongoDB
  Future<void> submitWritingAnswer() async {
    if (isAnswered.value) return;

    try {
      final targetAnswer =
          question.value?["answer"] ?? question.value?["kana"] ?? "";

      final result = await ApiService.submitQuizAnswer(
        userId: userId ?? "",
        sectionId: sectionId,
        questionNo: questionNo,
        answer: targetAnswer,
      );

      print("SUBMIT RESULT = $result");

      if (result["success"] == true && result["correct"] == true) {
        await ApiService.saveActivity(
          userId: userId ?? "",
          activityType: "quiz",
          title: "Mengerjakan Kuis",
          detail: "Berhasil menjawab soal nomor $questionNo - Menulis",
          score: 20,
        );

        isAnswered.value = true;
      }
    } catch (e) {
      print("SUBMIT ERROR = $e");
    }
  }

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

  bool isNearStroke(Offset point, StrokeData stroke) {
    final start = transformPoint(stroke.start.x, stroke.start.y);
    return (point - start).distance < 70;
  }

  void startStroke(Offset point) {
    if (!canvasReady) return;
    if (strokeData.isEmpty) return;
    if (currentStroke.value >= strokeData.length) return;

    final stroke = strokeData[currentStroke.value];

    if (!isNearStroke(point, stroke)) {
      showStatus("salah");
      return;
    }

    isDrawing = true;
    tempStroke.clear();
    tempStroke.add(point);
    lastPoint = point;
    update();
  }

  void addPoint(Offset point) {
    if (!isDrawing) return;

    if (lastPoint != null) {
      final dist = (point - lastPoint!).distance;

      if (dist < 2) return;

      if (dist > 150) {
        isDrawing = false;
        tempStroke.clear();
        lastPoint = null;
        showStatus("salah");
        update();
        return;
      }
    }

    lastPoint = point;
    tempStroke.add(point);
    update();
  }

  Future<void> endStroke() async {
    if (!isDrawing) return;
    if (lastPoint == null) return;

    final stroke = strokeData[currentStroke.value];
    final start = transformPoint(stroke.start.x, stroke.start.y);
    final end = transformPoint(stroke.end.x, stroke.end.y);
    final endDist = (lastPoint! - end).distance;

    final userStart = tempStroke.first;
    final userEnd = tempStroke.last;

    final jsonDx = end.dx - start.dx;
    final jsonDy = end.dy - start.dy;
    final userDx = userEnd.dx - userStart.dx;
    final userDy = userEnd.dy - userStart.dy;

    final expectedLength = (end - start).distance;
    final userLength = (userEnd - userStart).distance;

    final lengthRatio = userLength / expectedLength;

    final isLengthCorrect = lengthRatio >= 0.5 && lengthRatio <= 1.5;

    final dot = (jsonDx * userDx) + (jsonDy * userDy);
    final jsonLength = sqrt((jsonDx * jsonDx) + (jsonDy * jsonDy));
    final userVectorLength = sqrt((userDx * userDx) + (userDy * userDy));

    double similarity = 0;
    if (jsonLength > 0 && userLength > 0) {
      similarity = dot / (jsonLength * userLength);
    }

    final isDirectionCorrect = similarity > 0.4;
    final isEndCorrect = endDist < 110;

    if (isDirectionCorrect && isEndCorrect && isLengthCorrect) {
      showStatus("benar");

      points.addAll(tempStroke);
      points.add(null);
      tempStroke.clear();

      currentStroke.value++;

      // Sukses stroke, tapi keputusan benar/salah & submit akan dilakukan saat Konfirmasi (OCR)
      if (currentStroke.value >= strokeData.length) {
        isAllStrokesDone.value = true;
        strokeStatus.value = "";

        await submitWritingAnswer();

        final quizC = Get.find<QuizController>();
        quizC.jawab(isBenar: true);

        showSuccessDialog();
      }
    } else {
      showStatus("salah");
      tempStroke.clear();
    }

    isDrawing = false;
    lastPoint = null;
    update();
  }

  void showSuccessDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 80, color: Colors.green),

              const SizedBox(height: 16),

              const Text(
                "Benar!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text("Nomor berikutnya terbuka"),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Get.back(); // tutup dialog
                    final quizC = Get.find<QuizController>();
                    await quizC.loadData();
                    Get.back(); // kembali ke roadmap
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green, // Warna konsisten sukses (Hijau)
                    foregroundColor: Colors.white,
                    elevation: 2, // Efek bayangan halus
                  ),
                  child: const Text("Selesai"),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void clearCanvas() {
    points.clear();
    tempStroke.clear();
    currentStroke.value = 0;
    isDrawing = false;
    lastPoint = null;
    strokeStatus.value = "";
    isAnswered.value = false;
    update();
  }

  void undo() {
    if (points.isEmpty) return;

    while (points.isNotEmpty && points.last == null) {
      points.removeLast();
    }

    while (points.isNotEmpty && points.last != null) {
      points.removeLast();
    }

    if (currentStroke.value > 0) {
      currentStroke.value--;
    }

    // reset confirm/OCR state
    isAllStrokesDone.value = false;

    update();
  }
}
