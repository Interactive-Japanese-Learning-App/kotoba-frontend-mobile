import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotoba_app/app/modules/quiz/quiz/quiz_controller.dart';

class PuzzleController extends GetxController {

  final options = [
    "さ",
    "し",
    "か",
    "す",
    "く",
  ];

  final selectedAnswers = <String>[].obs;

  final correctAnswers = [
    "さ",
    "し",
    "す",
  ];

  /// PILIH
  void selectAnswer(String answer) {

    if (selectedAnswers.contains(answer)) return;

    if (selectedAnswers.length >= 3) return;

    selectedAnswers.add(answer);

    /// CEK
    if (selectedAnswers.length == 3) {

      Future.delayed(
        const Duration(milliseconds: 300),
        () {

          if (isCorrect()) {

            showSuccessDialog();

          } else {

            showWrongDialog();
          }
        },
      );
    }
  }

  /// CEK BENAR
  bool isCorrect() {

    return selectedAnswers.join("") ==
        correctAnswers.join("");
  }

  /// POPUP BENAR
  void showSuccessDialog() {

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// ICON
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80,
              ),

              const SizedBox(height: 16),

              /// TITLE
              const Text(
                "Benar!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              /// SUBTITLE
              const Text(
                "Puzzle berhasil diselesaikan",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 20),

              /// BUTTON
              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: () {
                    final quizC = Get.find<QuizController>();
                    quizC.jawab(isBenar: true);

                    Get.back(); // tutup dialog
                    Get.back(); // kembali quiz
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  child: const Text(
                    "Kembali ke Quiz",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      barrierDismissible: false,
    );
  }

  /// POPUP SALAH
  void showWrongDialog() {

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// ICON
              const Icon(
                Icons.cancel,
                color: Colors.red,
                size: 80,
              ),

              const SizedBox(height: 16),

              /// TITLE
              const Text(
                "Oops!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              /// SUBTITLE
              const Text(
                "Jawaban masih salah",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 20),

              /// BUTTON
              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: () {

                    Get.back();

                    selectedAnswers.clear();
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  child: const Text(
                    "Coba Lagi",
                  ),
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