import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return selectedIndex.value == 0
        ? hiragana
        : katakana;
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
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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

              const Text(
                "Yeay! Luar Biasa",
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () => Get.back(),
                child: const Text("Tutup"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}