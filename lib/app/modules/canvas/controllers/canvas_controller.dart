import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CanvasController extends GetxController {
  /// 🔥 JANGAN PAKAI OBS DI SINI
  final List<Offset?> points = [];

  /// DATA
  final label = ''.obs;
  final kana = ''.obs;
  final type = ''.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};
    label.value = args['label'] ?? '';
    kana.value = args['kana'] ?? '';
    type.value = args['type'] ?? '';
  }

  /// ➕ TAMBAH TITIK
  void addPoint(Offset point) {
    points.add(point);
    update(); // 🔥 trigger repaint ringan
  }

  /// 🔚 AKHIR GARIS
  void endStroke() {
    points.add(null);
    update();
  }

  /// 🧹 CLEAR
  void clearCanvas() {
    points.clear();
    update();
  }

  /// ↩️ UNDO
  void undo() {
    if (points.isEmpty) return;

    while (points.isNotEmpty) {
      final last = points.removeLast();
      if (last == null) break;
    }
    update();
  }

  /// 🎉 POPUP
  void showSuccessDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),

              const SizedBox(height: 16),

              const Text(
                "Yeay! Luar Biasa",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                "Latihan berhasil diselesaikan",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Tutup"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
