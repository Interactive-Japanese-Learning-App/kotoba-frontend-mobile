import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/services/api_service.dart';
import '../quiz/quiz_controller.dart';

class Membaca1Controller extends GetxController {
  final isLoading = true.obs;

  final selectedAnswer = "".obs;

  final isAnswered = false.obs;

  final question = Rxn<Map<String, dynamic>>();

  final box = GetStorage();

  late String sectionId;
  late String sectionTitle;
  late int questionNo;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};

    sectionId = args["sectionId"] ?? "";

    sectionTitle = args["sectionTitle"] ?? "";

    questionNo = args["questionNo"] ?? 1;

    if (sectionId.isNotEmpty) {
      loadQuestion();
    }
  }

  Future<void> loadQuestion() async {
    try {
      isLoading.value = true;

      final response = await ApiService.getQuizQuestions(sectionId);

      if (response["success"] == true) {
        final questions = response["data"] as List;

        question.value = questions.firstWhere(
          (e) => e["questionNo"] == questionNo,
          orElse: () => questions.first,
        );
      }
    } catch (e) {
      print("Load Question Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void selectAnswer(String answer) {
    if (isAnswered.value) return;

    selectedAnswer.value = answer;

    isAnswered.value = true;

    Future.delayed(const Duration(milliseconds: 400), () async {
      await submitAnswer();
    });
  }

  Future<void> submitAnswer() async {
    try {
      final userId = box.read('userId');

      if (userId == null) {
        Get.snackbar("Error", "User belum login");
        return;
      }

      final response = await ApiService.submitQuizAnswer(
        userId: userId,
        sectionId: sectionId,
        questionNo: questionNo,
        answer: selectedAnswer.value,
      );

      print("SUBMIT RESPONSE => $response");

      if (response["correct"] == true) {
        await Get.find<QuizController>().loadData();

        showSuccessDialog();
      } else {
        showWrongDialog();
      }
    } catch (e) {
      print("Submit Answer Error: $e");
    }
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

              const SizedBox(height: 8),

              const Text("Nomor berikutnya terbuka"),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // tutup dialog
                    Get.back(); // kembali ke halaman sebelumnya
                  },
                  // GANTI STYLE DI SINI
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cancel, size: 80, color: Colors.red),

              const SizedBox(height: 16),

              const Text(
                "Salah!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

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
                  // GANTI STYLE DI SINI
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red, // Disamakan jadi warna Merah murni
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
