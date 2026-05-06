import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/theme/app_colors.dart';
import '../../../widgets/drawing_painter.dart';
import 'menulis_controller.dart';

class MenulisView extends GetView<MenulisController> {
  const MenulisView({super.key});

  @override
  Widget build(BuildContext context) {
    final q = controller.question; // ✔ aman sekarang

    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
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

      body: Column(
        children: [
          const SizedBox(height: 10),

          /// TYPE
          Text(
            q["type"]!,
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 5),

          /// LABEL + KANA
          Text(
            "${q["label"]} (${q["kana"]})",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
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
                  ),
                  child: GestureDetector(
                    onPanUpdate: (d) => c.addPoint(d.localPosition),
                    onPanEnd: (_) => c.endStroke(),

                    child: CustomPaint(
                      painter: DrawingPainter(c.points),
                      child: Center(
                        child: Text(
                          q["kana"]!,
                          style: TextStyle(
                            fontSize: 150,
                            color: Colors.grey.withOpacity(0.25),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          /// BUTTON
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _btn("Hapus", Icons.delete, controller.clearCanvas),
              _btn("Batalkan", Icons.undo, controller.undo),
            ],
          ),

          const SizedBox(height: 20),

          /// KONFIRMASI
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

  Widget _btn(String text, IconData icon, VoidCallback onTap) {
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
            Text(text, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}