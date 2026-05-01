import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/theme/app_colors.dart';
import '../../../widgets/drawing_painter.dart';

class CanvasView extends StatefulWidget {
  const CanvasView({super.key});

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> {
  List<Offset?> points = [];

  /// 🔁 UNDO (hapus 1 stroke)
  void undo() {
    if (points.isEmpty) return;

    while (points.isNotEmpty) {
      final last = points.removeLast();
      if (last == null) break;
    }

    setState(() {});
  }

  /// 🎉 POPUP SUKSES
  void showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// ✅ ICON HIJAU
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 60,
                  ),
                ),

                const SizedBox(height: 20),

                /// TEXT
                const Text(
                  "Yeay! Luar Biasa",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 10),

                /// TOMBOL TUTUP
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Tutup"),
                ),
              ],
            ),
          ),
        );
      },
    );

    /// auto close (opsional)
    Future.delayed(const Duration(seconds: 2), () {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};

    final label = args['label'] ?? '';
    final kana = args['kana'] ?? '';
    final type = args['type'] ?? '';

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
        centerTitle: true,
      ),

      body: Column(
        children: [

          const SizedBox(height: 10),

          /// TYPE
          Text(
            type,
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 5),

          /// LABEL + KANA
          Text(
            "$label ($kana)",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 20),

          /// 🎨 CANVAS
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.neutral,
                borderRadius: BorderRadius.circular(20),
              ),
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    points.add(details.localPosition);
                  });
                },
                onPanEnd: (_) => points.add(null),

                child: CustomPaint(
                  painter: DrawingPainter(points),
                  child: Stack(
                    children: [

                      /// 🔤 BACKGROUND HURUF
                      Center(
                        child: Text(
                          kana,
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

          const SizedBox(height: 20),

          /// 🔘 BUTTON
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              /// HAPUS
              _buildButton("Hapus", Icons.delete, () {
                setState(() {
                  points.clear();
                });
              }),

              /// UNDO
              _buildButton("Batalkan", Icons.undo, undo),

              /// DAFTAR
              _buildButton("Daftar", Icons.list, () {
                Get.back();
              }),
            ],
          ),

          const SizedBox(height: 20),

          /// 🔴 KONFIRMASI
          GestureDetector(
            onTap: showSuccessDialog,
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
                    fontWeight: FontWeight.w500,
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

  /// 🔘 BUTTON WIDGET
  Widget _buildButton(String title, IconData icon, VoidCallback onTap) {
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