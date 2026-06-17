import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/theme/app_colors.dart';
import 'membaca2_controller.dart';

class Membaca2View extends GetView<Membaca2Controller> {
  const Membaca2View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leadingWidth: 50,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.primary,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Membaca 2",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.question.value == null) {
          return const Center(
            child: Text(
              "Soal tidak ditemukan",
            ),
          );
        }

        final question =
            controller.question.value!;

        final options =
            question["options"] as List;

        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),

              child: Column(
                children: [
                  const SizedBox(height: 20),

                  /// SECTION TITLE
                  Text(
                    controller.sectionTitle
                        .toUpperCase(),
                    style: TextStyle(
                      color:
                          Colors.grey.shade500,
                      fontSize: 11,
                      letterSpacing: 3,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Pilih huruf Jepang yang benar",
                    style: TextStyle(
                      color:
                          Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// SOAL
                  Text(
                    question["question"]
                        .toString(),
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      color:
                          AppColors.primary,
                      fontSize: 48,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// OPTIONS
                  ...List.generate(
                    options.length,
                    (index) {
                      final option =
                          options[index]
                              .toString();

                      final selected =
                          controller
                                  .selectedAnswer
                                  .value ==
                              option;

                      Color bgColor =
                          const Color(
                            0xFFD6D9DD,
                          );

                      if (controller
                          .isAnswered
                          .value) {
                        if (option ==
                            question[
                                "answer"]) {
                          bgColor =
                              Colors.green;
                        } else if (selected) {
                          bgColor =
                              Colors.red;
                        }
                      }

                      return Padding(
                        padding:
                            const EdgeInsets.only(
                          bottom: 16,
                        ),

                        child: GestureDetector(
                          onTap: () =>
                              controller
                                  .selectAnswer(
                            option,
                          ),

                          child:
                              AnimatedContainer(
                            duration:
                                const Duration(
                              milliseconds:
                                  250,
                            ),

                            width:
                                double.infinity,

                            height: 56,

                            decoration:
                                BoxDecoration(
                              color:
                                  bgColor,

                              borderRadius:
                                  BorderRadius.circular(
                                30,
                              ),
                            ),

                            child: Center(
                              child: Text(
                                option,

                                style:
                                    TextStyle(
                                  color: controller
                                          .isAnswered
                                          .value
                                      ? Colors
                                          .white
                                      : AppColors
                                          .primary,

                                  fontSize:
                                      22,

                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}