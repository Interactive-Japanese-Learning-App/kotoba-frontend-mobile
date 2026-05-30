import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/theme/app_colors.dart';
import '../../../widgets/drawing_painter.dart';
import 'menulis_controller.dart';

class MenulisView extends GetView<MenulisController> {
  const MenulisView({super.key});

  @override
  Widget build(BuildContext context) {
    final q = controller.question;

    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Menulis",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          /// TYPE
          Text(
            q["type"]!,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 5),

          /// LABEL
          Text(
            "Tuliskan huruf ${q["label"]}",
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
                            /// GRID BACKGROUND
                            CustomPaint(
                              size: Size.infinite,
                              painter: GridPainter(),
                            ),

                            /// USER DRAWING
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
              _button(
                "Hapus",
                Icons.delete,
                controller.clearCanvas,
              ),

              _button(
                "Undo",
                Icons.undo,
                controller.undo,
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// KONFIRMASI
          GestureDetector(
            onTap: () {
              Get.snackbar(
                "OCR",
                "Nanti proses OCR di sini",
                backgroundColor: Colors.blue.shade100,
              );
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
                child: Text(
                  "Konfirmasi",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _button(
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
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

            Text(
              title,
              style: const TextStyle(fontSize: 12),
            ),
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