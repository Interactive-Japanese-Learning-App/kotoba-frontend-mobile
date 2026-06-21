import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/theme/app_colors.dart';
import '../../../widgets/drawing_painter.dart';
import 'menulis_controller.dart';
import '../../../widgets/kana_image_background_painter.dart';

class MenulisView extends GetView<MenulisController> {
  const MenulisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leadingWidth: 50,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Menulis",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final q = controller.question.value ?? {};

        return SafeArea(
          top: false,
          bottom: true,
          child: Column(
            children: [
              const SizedBox(height: 10),

              /// SECTION TITLE
              Text(
                controller.sectionTitle.toUpperCase(),
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 11,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Tuliskan huruf Jepang berikut",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),

              const SizedBox(height: 10),

              /// SOAL
              Text(
                q["question"]?.toString() ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              /// CANVAS
              Expanded(
                child: GetBuilder<MenulisController>(
                  builder: (c) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppColors.neutral,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: c.strokeStatus.value == "benar"
                              ? Colors.green
                              : c.strokeStatus.value == "salah"
                              ? Colors.red
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onPanStart: (details) {
                          c.startStroke(details.localPosition);
                        },
                        onPanUpdate: (details) {
                          c.addPoint(details.localPosition);
                        },
                        onPanEnd: (_) {
                          c.endStroke();
                        },
                        child: GetBuilder<MenulisController>(
                          builder: (_) {
                            return Stack(
                              children: [
                                /// GRID
                                CustomPaint(
                                  size: Size.infinite,
                                  painter: GridPainter(),
                                ),

                                /// BACKGROUND HURUF ぬ
                                CustomPaint(
                                  size: Size.infinite,
                                  painter: KanaImageBackgroundPainter(
                                    assetPath: 'assets/kana_images/ぬ_0306c.svg',
                                  ),
                                ),

                                /// CORETAN USER
                                CustomPaint(
                                  size: Size.infinite,
                                  painter: DrawingPainter([
                                    ...c.points,
                                    ...c.tempStroke,
                                  ]),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// BUTTONS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _button("Hapus", Icons.delete, controller.clearCanvas),
                  _button("Undo", Icons.undo, controller.undo),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _button(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.neutral,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

/// GRID BACKGROUND
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.15)
      ..strokeWidth = 1;

    /// garis tengah vertikal
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );

    /// garis tengah horizontal
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}