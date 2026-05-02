import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotoba_app/app/modules/quiz/controllers/quiz_controller.dart';
import 'package:kotoba_app/app/routes/app_pages.dart';
import '../../../data/theme/app_colors.dart';

class QuizView extends GetView<QuizController> {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      /// 🔥 APPBAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,

        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),

        title: Text(
          "Quiz",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),

        child: Column(
          children: [
            const SizedBox(height: 20),

            /// 🔥 HIRAGANA
            _quizSection(
              title: "Hiragana",
              icon: "あ",
              color: AppColors.danger,
              levels: controller.sections[0]["levels"] as List,
            ),

            const SizedBox(height: 60),

            /// 🔥 KATAKANA
            _quizSection(
              title: "Katakana",
              icon: "ア",
              color: AppColors.primary,
              levels: controller.sections[1]["levels"] as List,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _quizSection({
    required String title,
    required String icon,
    required Color color,
    required List levels,
  }) {
    return Column(
      children: [
        /// 🔥 CARD
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),

          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(28),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// TEXT
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
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              /// ICON
              Container(
                width: 58,
                height: 58,

                decoration: BoxDecoration(
                  color: AppColors.warning,
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Center(
                  child: Text(
                    icon,
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

        /// 🔥 MAP
        SizedBox(
          height: 620,

          child: LayoutBuilder(
            builder: (context, constraints) {
              final center = constraints.maxWidth / 2;

              return Stack(
                children: [
                  /// 🔥 PATH
                  Positioned.fill(
                    child: CustomPaint(painter: DuolingoPathPainter()),
                  ),

                  /// 🔥 BUTTONS
                  ...List.generate(levels.length, (i) {
                    final unlocked = levels[i];

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
                                if (i == 0) {
                                  Get.toNamed(Routes.QUIZ_MEMBACA1);
                                } else if (i == 1) {
                                  Get.toNamed(Routes.QUIZ_MEMBACA2);
                                } else if (i == 2) {
                                  Get.toNamed(Routes.QUIZ_PUZZLE);
                                } else if (i == 3) {
                                  Get.toNamed(Routes.QUIZ_MENULIS);
                                } else if (i == 4) {
                                  Get.toNamed(Routes.QUIZ_PELAFALAN);
                                }
                              }
                            : null,

                        child: Column(
                          children: [
                            /// 🔥 BULATAN
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

                                boxShadow: unlocked
                                    ? [
                                        BoxShadow(
                                          color: color.withOpacity(0.25),
                                          blurRadius: 16,
                                          offset: const Offset(0, 8),
                                        ),
                                      ]
                                    : [],
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

                            /// 🔥 LABEL
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),

                              child: Text(
                                [
                                  "Membaca 1",
                                  "Membaca 2",
                                  "Puzzle",
                                  "Menulis",
                                  "Pelafalan",
                                ][i],

                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
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

/// 🔥 PATH PAINTER
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

    /// DRAW
    canvas.drawPath(path, outerPaint);

    /// DASH
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
