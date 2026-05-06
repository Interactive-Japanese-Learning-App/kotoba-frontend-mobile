import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          Obx(() => Text(
                controller.type.value,
                style: const TextStyle(color: Colors.grey),
              )),

          const SizedBox(height: 5),

          /// 🔷 LABEL
          Obx(() => Text(
                "${controller.label.value} (${controller.kana.value})",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              )),

          const SizedBox(height: 20),

          /// 🔥 CANVAS (SUPER RESPONSIVE - NO DELAY)
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.neutral,
                borderRadius: BorderRadius.circular(20),
              ),

              child: GestureDetector(
                onPanStart: (details) {
                  controller.addPoint(details.localPosition);
                },
                onPanUpdate: (details) {
                  controller.addPoint(details.localPosition);
                },
                onPanEnd: (_) => controller.endStroke(),

                /// 🔥 PENTING: pakai GetBuilder (lebih cepat dari Obx)
                child: GetBuilder<CanvasController>(
                  builder: (_) => CustomPaint(
                    painter: DrawingPainter(controller.points),
                    child: Stack(
                      children: [
                        /// BACKGROUND HURUF
                        Center(
                          child: Text(
                            controller.kana.value,
                            style: TextStyle(
                              fontSize: 150,
                              color: Colors.grey.withOpacity(0.25),
                            ),
                          ),
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
            onTap: controller.showSuccessDialog,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text(
                  "Konfirmasi",
                  style: TextStyle(color: Colors.white),
                ),
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