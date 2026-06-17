import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kotoba_app/app/modules/quiz/puzzle/puzzle_controller.dart';
import '../../../data/theme/app_colors.dart';

class PuzzleView extends GetView<PuzzleController> {
  const PuzzleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Puzzle",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final question = controller.question.value;

        if (question == null) {
          return const Center(child: Text("Soal tidak ditemukan"));
        }

        /// AMBIL OPTIONS DARI BACKEND
        final options = (question["options"] as List<dynamic>)
            .map((e) => e.toString())
            .toList();

        /// PANJANG JAWABAN
        final answer = question["answer"]?.toString() ?? "";

        final answerLength = answer.characters.length;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// TITLE
                Text(
                  "SECTION 1",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Susun huruf berikut menjadi kata bahasa Jepang yang berarti Sayur",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),

                const SizedBox(height: 40),

                /// SOAL
                Text(
                  question["question"].toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                /// HINT
                Text(
                  question["hint"] ?? "",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                /// JAWABAN USER
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(answerLength, (index) {
                    String text = "";

                    if (index < controller.selectedAnswers.length) {
                      text = controller.selectedAnswers[index];
                    }

                    return Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: text.isNotEmpty
                                ? AppColors.primary
                                : Colors.grey,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: 34,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 60),

                /// PILIHAN HURUF
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: options.map((item) {
                    final selected = controller.selectedAnswers.contains(item);

                    return GestureDetector(
                      onTap: selected
                          ? null
                          : () => controller.selectAnswer(item),

                      child: Container(
                        width: 90,
                        height: 58,
                        decoration: BoxDecoration(
                          color: selected
                              ? Colors.green
                              : const Color(0xFFD6D9DD),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            item,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : AppColors.primary,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      }),
    );
  }
}
