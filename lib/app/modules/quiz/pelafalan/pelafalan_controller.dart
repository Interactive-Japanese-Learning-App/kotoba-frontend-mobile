import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotoba_app/app/modules/quiz/quiz/quiz_controller.dart';
import 'package:kotoba_app/app/routes/app_pages.dart';

class PelafalanController extends GetxController {
  /// SOAL
  final question = {"label": "a", "kana": "あ", "type": "HIRAGANA"};

  var isListening = false.obs;
  var isDialogOpen = false.obs;

  void toggleMic() {
    /// cegah double tap
    if (isListening.value) return;

    isListening.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      isListening.value = false;

      double accuracy = 100;
      _showResultDialog(accuracy);
    });
  }

  void _showResultDialog(double accuracy) {
    /// cegah dialog dobel
    if (isDialogOpen.value || (Get.isDialogOpen ?? false)) return;

    isDialogOpen.value = true;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.graphic_eq, color: Colors.green, size: 80),

              const SizedBox(height: 16),

              Text(
                "${accuracy.toStringAsFixed(0)}%",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Pelafalan selesai",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    isDialogOpen.value = false;

                    final quizC = Get.find<QuizController>();

                    quizC.setPelafalanAccuracy(accuracy);
                    quizC.jawab(isBenar: true);

                    // Tutup dialog secara pasti, lalu langsung pindah ke hasil.
                    if (Get.isDialogOpen ?? false) {
                      Get.back();
                    }

                    Get.offNamed(Routes.QUIZ_RESULT);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("LIhat Hasil Quiz"),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.3),
      barrierDismissible: false,
    );
  }
}