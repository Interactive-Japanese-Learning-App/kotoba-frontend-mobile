import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenulisController extends GetxController {
  final question = {"label": "a", "kana": "あ", "type": "hiragana"};

  List<Offset?> points = [];

  void addPoint(Offset point) {
    points.add(point);
    update();
  }

  void endStroke() {
    points.add(null);
    update();
  }

  void clearCanvas() {
    points.clear();
    update();
  }

  void undo() {
    if (points.isEmpty) return;

    while (points.isNotEmpty) {
      final last = points.removeLast();
      if (last == null) break;
    }

    update();
  }

  /// 🎯 POPUP FINAL (INDO + BACK KE QUIZ)
  void showSuccessDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),

              const SizedBox(height: 16),

              /// TITLE
              const Text(
                "Bagus!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              /// SUBTITLE
              const Text(
                "Quiz menulis selesai",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              /// BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // tutup dialog
                    Get.back(); // balik ke halaman quiz
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Kembali ke Quiz"),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
