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
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primary,
            size: 20,
          ),
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
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),

            child: Column(
              children: [

                const SizedBox(height: 20),

                /// TITLE
                Text(
                  "HIRAGANA",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Susun huruf berikut",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 55),

                /// SOAL
                Text(
                  "sa shi su",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 70),

                /// HASIL PILIHAN
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: List.generate(
                    3,
                    (index) {

                      String text = "";

                      if (index <
                          controller.selectedAnswers.length) {

                        text =
                            controller.selectedAnswers[index];
                      }

                      return Container(
                        width: 65,
                        height: 65,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),

                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade400,
                              width: 3,
                            ),
                          ),
                        ),

                        child: Center(
                          child: Text(
                            text,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 60),

                /// PILIHAN
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,

                  children: List.generate(
                    controller.options.length,
                    (index) {

                      final item =
                          controller.options[index];

                      return GestureDetector(
                        onTap: () =>
                            controller.selectAnswer(item),

                        child: Container(
                          width: 90,
                          height: 58,

                          decoration: BoxDecoration(
                            color: const Color(0xFFD6D9DD),
                            borderRadius:
                                BorderRadius.circular(30),
                          ),

                          child: Center(
                            child: Text(
                              item,

                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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