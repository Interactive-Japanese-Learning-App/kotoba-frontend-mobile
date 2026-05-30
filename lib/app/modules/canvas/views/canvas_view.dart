import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotoba_app/app/routes/app_pages.dart';
import 'package:kotoba_app/app/widgets/kana_background_painter.dart';
import 'package:kotoba_app/app/widgets/stroke_order_painter.dart';
import '../../../data/theme/app_colors.dart';
import '../../../widgets/drawing_painter.dart';

import '../controllers/canvas_controller.dart';

class CanvasView extends GetView<CanvasController> {
  const CanvasView({super.key});

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
          "Writing Canvas",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          /// 🔷 TYPE
          Obx(
            () => Text(
              controller.type.value,
              style: const TextStyle(color: Colors.grey),
            ),
          ),

          const SizedBox(height: 5),

          /// 🔷 LABEL
          Obx(
            () => Text(
              "${controller.label.value} (${controller.kana.value})",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// 🔥 CANVAS (SUPER RESPONSIVE - NO DELAY)
          /// 🔥 CANVAS
          Expanded(
            child: Obx(
              () => Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),

                decoration: BoxDecoration(
                  color: AppColors.neutral,
                  borderRadius: BorderRadius.circular(20),

                  border: Border.all(
                    color: controller.strokeStatus.value == "benar"
                        ? Colors.green
                        : controller.strokeStatus.value == "salah"
                        ? Colors.red
                        : Colors.transparent,
                    width: 4,
                  ),
                ),

                child: GestureDetector(
                  onPanStart: (details) {
                    controller.startStroke(details.localPosition);
                  },

                  onPanUpdate: (details) {
                    controller.addPoint(details.localPosition);
                  },

                  onPanEnd: (_) {
                    if (controller.lastPoint != null) {
                      controller.endStrokeCheck();
                    }
                  },

                  child: GetBuilder<CanvasController>(
                    builder: (_) => Stack(
                      children: [
                        /// 🔥 BACKGROUND HURUF
                        CustomPaint(
                          size: Size.infinite,
                          painter: KanaBackgroundPainter(controller.kana.value),
                        ),

                        /// 🔥 STROKE GUIDE
                        CustomPaint(
                          size: Size.infinite,
                          painter: StrokeOrderPainter(controller.strokeData),
                        ),

                        /// 🔥 USER DRAWING
                        CustomPaint(
                          size: Size.infinite,
                          painter: DrawingPainter(controller.points),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// 🔷 BUTTON
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _button("Hapus", Icons.delete, controller.clearCanvas),
              _button("Undo", Icons.undo, controller.undo),

              /// 🔥 FIX DI SINI
              _button("Daftar", Icons.list, () => Get.back()),
            ],
          ),

          const SizedBox(height: 20),

          /// 🔷 KONFIRMASI
          GestureDetector(
            onTap: () {
              if (controller.isCompleted()) {
                Get.dialog(
                  Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 80,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Bagus!",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Huruf berhasil ditulis",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                Future.delayed(const Duration(seconds: 2), () {
                  Get.back();
                  Get.back();
                });
              } else {
                Get.snackbar("Belum selesai", "Selesaikan semua stroke dulu");
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text("Selesai", style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// 🔷 BUTTON
  Widget _button(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
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
