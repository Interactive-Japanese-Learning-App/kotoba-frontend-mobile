import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/services/api_service.dart';
import '../quiz/quiz_controller.dart';

class PuzzleController extends GetxController {
  final isLoading = true.obs;

  final selectedAnswers = <String>[].obs;

  final isAnswered = false.obs;

  final question = Rxn<Map<String, dynamic>>();

  late String sectionId;
  late String sectionTitle;
  late int questionNo;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};

    sectionId = args["sectionId"] ?? "";
    sectionTitle = args["sectionTitle"] ?? "";
    questionNo = args["questionNo"] ?? 3;

    loadQuestion();
  }

  Future<void> loadQuestion() async {
    try {
      isLoading.value = true;

      final response = await ApiService.getQuizQuestions(sectionId);

      if (response["success"] == true) {
        final questions = List<Map<String, dynamic>>.from(
          response["data"] ?? [],
        );

        question.value = questions.firstWhere(
          (q) => q["questionNo"] == questionNo,
          orElse: () => {},
        );

        if (question.value!.isEmpty) {
          question.value = null;
        }
      }
    } catch (e) {
      print("LOAD PUZZLE ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void selectAnswer(String answer) {
    if (isAnswered.value) return;

    final targetLength =
        question.value?["answer"]?.toString().characters.length ?? 0;

    if (selectedAnswers.length >= targetLength) {
      return;
    }

    selectedAnswers.add(answer);

    if (selectedAnswers.length == targetLength) {
      isAnswered.value = true;

      Future.delayed(const Duration(milliseconds: 400), () async {
        if (isCorrect()) {
          await submitAnswer();
        } else {
          showWrongDialog();
        }
      });
    }
  }

  bool isCorrect() {
    final answer = question.value?["answer"]?.toString() ?? "";

    return selectedAnswers.join("") == answer;
  }

  Future<void> submitAnswer() async {
    try {
      final userId = GetStorage().read("userId");

      if (userId == null) {
        Get.snackbar("Error", "User belum login");
        return;
      }

      final response = await ApiService.submitQuizAnswer(
        userId: userId,
        sectionId: sectionId,
        questionNo: questionNo,
        answer: selectedAnswers.join(""),
      );

      if (response["correct"] == true) {
        final quizC = Get.find<QuizController>();
        quizC.jawab(isBenar: true);
        showSuccessDialog();
      } else {
        showWrongDialog();
      }
    } catch (e) {
      print("SUBMIT PUZZLE ERROR: $e");
    }
  }

  void showSuccessDialog() {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),

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
                    final quizC = Get.find<QuizController>();
                    await quizC.loadData();
                    Get.back(); // tutup dialog
                    Get.back(); // kembali ke roadmap
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Warna sukses (Hijau)
                    foregroundColor: Colors.white,
                    elevation: 2, // Memberikan efek bayangan timbul halus
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

  void showWrongDialog() {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cancel, color: Colors.red, size: 80),

              const SizedBox(height: 16),

              const Text(
                "Salah!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text("Coba lagi"),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    selectedAnswers.clear();
                    isAnswered.value = false;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red, // Disamakan menjadi warna Merah murni
                    foregroundColor: Colors.white,
                    elevation: 2, // Memberikan efek bayangan timbul halus
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