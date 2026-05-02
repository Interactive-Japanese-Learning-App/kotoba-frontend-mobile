import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PelafalanController extends GetxController {
  /// 🎯 SOAL
  final question = {"label": "a", "kana": "あ", "type": "HIRAGANA"};

  var isListening = false.obs;

  /// 🔥 TAMBAH INI (WAJIB)
  var isDialogOpen = false.obs;

  void toggleMic() {
    isListening.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      isListening.value = false;

      double accuracy = 100;
      _showResultDialog(accuracy);
    });
  }

  void _showResultDialog(double accuracy) {
    if (isDialogOpen.value) return;

    isDialogOpen.value = true;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.graphic_eq,
                color: Colors.green,
                size: 80,
              ),

              const SizedBox(height: 16),

              Text(
                "${accuracy.toStringAsFixed(0)}%",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Pelafalan selesai",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    isDialogOpen.value = false;

                    Get.back(); // close dialog
                    Get.back(); // back quiz
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Kembali ke Quiz"),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.3),
      barrierDismissible: false,
    );
  }
}