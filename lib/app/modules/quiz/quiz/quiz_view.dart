import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kotoba_app/app/modules/main/controllers/bottom_nav_controller.dart';
import 'package:kotoba_app/app/modules/quiz/quiz/quiz_controller.dart';
import 'package:kotoba_app/app/routes/app_pages.dart';

import '../../../data/models/quiz_section_model.dart';
import '../../../data/theme/app_colors.dart';

class QuizView extends GetView<QuizController> {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () {
            Get.offNamed(Routes.MAIN);

            Future.delayed(Duration.zero, () {
              Get.find<BottomNavController>().changeIndex(2);
            });
          },
        ),
        title: Text(
          "Quiz",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.sections.isEmpty) {
          return const Center(child: Text("Belum ada section"));
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              children: List.generate(controller.sections.length, (index) {
                final section = controller.sections[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: _quizSection(
                    section: section,
                    sectionNumber: index + 1,
                  ),
                );
              }),
            ),
          ),
        );
      }),
    );
  }

  Widget _quizSection({
    required QuizSection section,
    required int sectionNumber,
  }) {
    final sectionUnlocked = controller.isSectionUnlocked(sectionNumber);

    final color = Color(int.parse(section.color.replaceFirst("#", "0xff")));

    return Column(
      children: [
        /// HEADER
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: sectionUnlocked ? color : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "QUIZ SECTION",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    section.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.warning,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    "${sectionNumber}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 35),

        /// ROADMAP
        SizedBox(
          height: 620,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final center = constraints.maxWidth / 2;

              return Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(painter: DuolingoPathPainter()),
                  ),

                  ...List.generate(5, (i) {
                    final questionNo = i + 1;

                    final unlocked = controller.isQuestionUnlocked(
                      sectionNumber,
                      questionNo,
                    );

                    double left;

                    if (i == 0) {
                      left = center - 45;
                    } else if (i == 1) {
                      left = center + 45;
                    } else if (i == 2) {
                      left = center - 45;
                    } else if (i == 3) {
                      left = center - 135;
                    } else {
                      left = center - 25;
                    }

                    return Positioned(
                      top: i * 110,
                      left: left,
                      child: GestureDetector(
                        onTap: unlocked
                            ? () {
                                switch (i) {
                                  case 0:
                                    Get.toNamed(
                                      Routes.QUIZ_MEMBACA1,
                                      arguments: {
                                        "sectionId": section.id,
                                        "sectionTitle": section.title,
                                      },
                                    );
                                    break;

                                  case 1:
                                    Get.toNamed(
                                      Routes.QUIZ_MEMBACA2,
                                      arguments: {
                                        "sectionId": section.id,
                                        "sectionTitle": section.title,
                                      },
                                    );
                                    break;

                                  case 2:
                                    Get.toNamed(
                                      Routes.QUIZ_PUZZLE,
                                      arguments: {
                                        "sectionId": section.id,
                                        "sectionTitle": section.title,
                                      },
                                    );
                                    break;

                                  case 3:
                                    Get.toNamed(
                                      Routes.QUIZ_MENULIS,
                                      arguments: {
                                        "sectionId": section.id,
                                        "sectionTitle": section.title,
                                      },
                                    );
                                    break;

                                  case 4:
                                    Get.toNamed(
                                      Routes.QUIZ_PELAFALAN,
                                      arguments: {
                                        "sectionId": section.id,
                                        "sectionTitle": section.title,
                                      },
                                    );
                                    break;

                                }
                              }
                            : null,
                        child: Column(
                          children: [
                            Container(
                              width: 92,
                              height: 92,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: unlocked ? color : Colors.grey.shade300,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 5,
                                ),
                              ),
                              child: Icon(
                                [
                                  Icons.menu_book_rounded,
                                  Icons.book_rounded,
                                  Icons.extension_rounded,
                                  Icons.edit_note_rounded,
                                  Icons.mic_rounded,
                                ][i],
                                size: 40,
                                color: unlocked
                                    ? Colors.white
                                    : Colors.grey.shade500,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              [
                                "Membaca 1",
                                "Membaca 2",
                                "Puzzle",
                                "Menulis",
                                "Pelafalan",
                              ][i],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class DuolingoPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final outerPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final innerPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;

    final path = Path();

    path.moveTo(centerX, 45);

    path.quadraticBezierTo(centerX + 120, 95, centerX + 85, 175);

    path.quadraticBezierTo(centerX + 40, 245, centerX, 265);

    path.quadraticBezierTo(centerX - 135, 315, centerX - 90, 395);

    path.quadraticBezierTo(centerX - 60, 480, centerX, 520);

    canvas.drawPath(path, outerPaint);

    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;

      while (distance < metric.length) {
        final miniPath = metric.extractPath(distance, distance + 14);

        canvas.drawPath(miniPath, innerPaint);

        distance += 28;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
