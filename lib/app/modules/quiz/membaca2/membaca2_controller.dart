import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:kotoba_app/app/modules/quiz/quiz/quiz_controller.dart';

class Membaca2Controller extends GetxController {
  var selectedAnswer = "".obs;
  var isAnswered = false.obs;

  /// 🔥 pakai tipe aman (NO NULL ERROR)
  final Map<String, dynamic> question = {
    "question": "a",
    "answer": "あ",
    "options": ["あ", "い", "う"],
  };

  void selectAnswer(String answer) {
    if (isAnswered.value) return;

    selectedAnswer.value = answer;
    isAnswered.value = true;

    Future.delayed(const Duration(milliseconds: 300), () {
      if (isCorrect()) {
        showSuccessDialog();
      } else {
        showWrongDialog();
      }
    });
  }

  bool isCorrect() {
    return selectedAnswer.value == question["answer"];
  }

  void showSuccessDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 80, color: Colors.green),
              const SizedBox(height: 16),
              const Text("Benar!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Jawaban kamu tepat"),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final quizC = Get.find<QuizController>();
                    quizC.jawab(isBenar: true);

                    Get.back();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
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

  void showWrongDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cancel, size: 80, color: Colors.red),
              const SizedBox(height: 16),
              const Text("Salah!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Coba lagi ya"),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    selectedAnswer.value = "";
                    isAnswered.value = false;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Coba Lagi"),
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