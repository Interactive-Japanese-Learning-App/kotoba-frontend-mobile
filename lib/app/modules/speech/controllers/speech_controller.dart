import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotoba_app/app/routes/app_pages.dart';

class SpeechController extends GetxController {
  /// TAB
  final selectedIndex = 0.obs;

  /// LISTENING
  final isListening = false.obs;

  /// DATA HIRAGANA
  final List<Map<String, String>> hiragana = [
    {'label': 'a', 'kana': 'あ'},
    {'label': 'i', 'kana': 'い'},
    {'label': 'u', 'kana': 'う'},
    {'label': 'e', 'kana': 'え'},
    {'label': 'o', 'kana': 'お'},
    {'label': 'ka', 'kana': 'か'},
    {'label': 'ki', 'kana': 'き'},
    {'label': 'ku', 'kana': 'く'},
  ];

  /// DATA KATAKANA
  final List<Map<String, String>> katakana = [
    {'label': 'a', 'kana': 'ア'},
    {'label': 'i', 'kana': 'イ'},
    {'label': 'u', 'kana': 'ウ'},
    {'label': 'e', 'kana': 'エ'},
  ];

  /// DATA ACTIVE
  List<Map<String, String>> get currentData {
    return selectedIndex.value == 0 ? hiragana : katakana;
  }

  /// CHANGE TAB
  void changeTab(int index) {
    selectedIndex.value = index;
  }

  /// MIC
  void toggleMic() {
    isListening.value = !isListening.value;

    if (!isListening.value) {
      showSuccessDialog();
    }
  }

  /// SUCCESS DIALOG
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
