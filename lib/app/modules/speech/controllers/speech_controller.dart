import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpeechController extends GetxController {
  /// 🔴 TAB INDEX
  var selectedIndex = 0.obs;

  /// 🔤 DATA
  final hiragana = [
    {'label': 'a', 'kana': 'あ'},
    {'label': 'i', 'kana': 'い'},
    {'label': 'u', 'kana': 'う'},
    {'label': 'e', 'kana': 'え'},
    {'label': 'o', 'kana': 'お'},
    {'label': 'ka', 'kana': 'か'},
    {'label': 'ki', 'kana': 'き'},
    {'label': 'ku', 'kana': 'く'},
  ];

  final katakana = [
    {'label': 'a', 'kana': 'ア'},
    {'label': 'i', 'kana': 'イ'},
    {'label': 'u', 'kana': 'ウ'},
    {'label': 'e', 'kana': 'エ'},
  ];

  /// 🔁 GANTI TAB
  void changeTab(int index) {
    selectedIndex.value = index;
  }

  /// 🔥 DATA AKTIF (FIX ERROR)
  List<Map<String, String>> get currentData =>
      selectedIndex.value == 0 ? hiragana : katakana;

  // ==========================
  // 🔽 DETAIL PAGE
  // ==========================

  var kana = ''.obs;
  var label = ''.obs;
  var type = ''.obs;
  var isListening = false.obs;

  @override
  void onInit() {
    super.onInit();

    /// 🔥 AMBIL ARGUMENT DARI NAVIGASI
    final args = Get.arguments ?? {};

    kana.value = args['kana'] ?? '';
    label.value = args['label'] ?? '';
    type.value = args['type'] ?? '';
  }

  /// 🎤 MIC
  void toggleMic() {
    isListening.value = !isListening.value;

    if (!isListening.value) {
      showSuccessDialog();
    }
  }

  /// 🎉 POPUP
  void showSuccessDialog() {
    Get.dialog(
      Dialog(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding:
              const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
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
                child: const Icon(Icons.check,
                    color: Colors.white, size: 60),
              ),
              const SizedBox(height: 20),
              const Text("Yeay! Luar Biasa",
                  style: TextStyle(fontSize: 16)),
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