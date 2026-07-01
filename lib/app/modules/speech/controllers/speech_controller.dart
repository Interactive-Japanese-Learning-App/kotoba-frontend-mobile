import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:dio/dio.dart';
import 'package:kana_kit/kana_kit.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/services/api_service.dart';

class SpeechItem {
  final String character;
  final String romaji;
  final String meaning;

  SpeechItem({
    required this.character,
    required this.romaji,
    required this.meaning,
  });

  factory SpeechItem.fromJson(Map<String, dynamic> json) {
    return SpeechItem(
      character: json["character"] ?? "",
      romaji: json["romaji"] ?? "",
      meaning: json["meaning"] ?? "",
    );
  }
}

class SpeechController extends GetxController {
  final isLoading = false.obs;
  final selectedIndex = 0.obs;

  final isListening = false.obs;

  final recognizedText = "".obs;

  final score = 0.0.obs;

  final numbers = <SpeechItem>[].obs;
  final months = <SpeechItem>[].obs;
  final dates = <SpeechItem>[].obs;
  final family = <SpeechItem>[].obs;
  final animals = <SpeechItem>[].obs;
  final foods = <SpeechItem>[].obs;
  final drinks = <SpeechItem>[].obs;
  final jobs = <SpeechItem>[].obs;
  final objects = <SpeechItem>[].obs;

  final SpeechToText speech = SpeechToText();
  final FlutterTts tts = FlutterTts();
  final Dio dio = Dio();
  final kanaKit = KanaKit();

  static const String baseUrl = 'http://192.168.18.9:5000/api';
  @override
  void onInit() {
    super.onInit();
    loadAllData();
    initSpeech();
  }

  Future<void> loadAllData() async {
    isLoading.value = true;

    await Future.wait([
      loadData("nihongo/numbers", numbers),
      loadData("nihongo/months", months),
      loadData("nihongo/dates", dates),
      loadData("nihongo/family", family),
      loadData("nihongo/animals", animals),
      loadData("nihongo/foods", foods),
      loadData("nihongo/drinks", drinks),
      loadData("nihongo/jobs", jobs),
      loadData("nihongo/object_vocab", objects),
    ]);

    isLoading.value = false;
  }

  Future<void> initSpeech() async {
    await speech.initialize();
  }

  Future<void> speak(String text) async {
    await tts.setLanguage("ja-JP");
    await tts.setSpeechRate(0.4);
    await tts.setPitch(1.0);

    await tts.speak(text);
  }

  String normalizeSpeech(String text) {
    text = text.trim().toLowerCase().replaceAll(" ", "");

    final Map<String, String> numberMap = {
      // ANGKA
      "1": "ichi",
      "2": "ni",
      "3": "san",
      "4": "yon",
      "5": "go",
      "6": "roku",
      "7": "nana",
      "8": "hachi",
      "9": "kyuu",
      "10": "juu",
      "11": "juuichi",
      "12": "juuni",
      "13": "juusan",
      "14": "juuyon",
      "15": "juugo",
      "16": "juuroku",
      "17": "juunana",
      "18": "juuhachi",
      "19": "juukyuu",
      "20": "nijuu",

      // BULAN
      "1月": "ichigatsu",
      "2月": "nigatsu",
      "3月": "sangatsu",
      "4月": "shigatsu",
      "5月": "gogatsu",
      "6月": "rokugatsu",
      "7月": "shichigatsu",
      "8月": "hachigatsu",
      "9月": "kugatsu",
      "10月": "juugatsu",
      "11月": "juuichigatsu",
      "12月": "juunigatsu",

      // TANGGAL
      "1日": "tsuitachi",
      "2日": "futsuka",
      "3日": "mikka",
      "4日": "yokka",
      "5日": "itsuka",
      "6日": "muika",
      "7日": "nanoka",
      "8日": "youka",
      "9日": "kokonoka",
      "10日": "tooka",
      "11日": "juuichinichi",
      "12日": "juuninichi",
      "13日": "juusannichi",
      "14日": "juuyokka",
      "15日": "juugonichi",
      "16日": "juurokunichi",
      "17日": "juushichinichi",
      "18日": "juuhachinichi",
      "19日": "juukunichi",
      "20日": "hatsuka",
      "21日": "nijuuichinichi",
      "22日": "nijuuninichi",
      "23日": "nijuusannichi",
      "24日": "nijuuyokka",
      "25日": "nijuugonichi",
      "26日": "nijuurokunichi",
      "27日": "nijuushichinichi",
      "28日": "nijuuhachinichi",
      "29日": "nijuukunichi",
      "30日": "sanjuunichi",
      "31日": "sanjuuichinichi",
    };
    if (numberMap.containsKey(text)) {
      return numberMap[text]!;
    }

    if (kanaKit.isRomaji(text)) {
      return text;
    }

    if (kanaKit.isHiragana(text) ||
        kanaKit.isKatakana(text) ||
        kanaKit.isMixed(text)) {
      return kanaKit.toRomaji(text);
    }

    return text;
  }

  /// =====================================================
  /// KALKULASI SKOR (FIX UNTUK KANJI VS HIRAGANA)
  /// =====================================================
  void calculateScore(String targetRomaji, String spoken) {
    if (spoken.isEmpty) {
      score.value = 0;
      return;
    }

    String expected = targetRomaji.trim().toLowerCase().replaceAll(" ", "");
    String heard = normalizeSpeech(spoken);

    if (!kanaKit.isRomaji(heard)) {
      final allItems = [
        ...numbers,
        ...months,
        ...dates,
        ...family,
        ...animals,
        ...foods,
        ...drinks,
        ...jobs,
        ...objects,
      ];

      for (final item in allItems) {
        if (item.romaji.trim().toLowerCase().replaceAll(" ", "") == expected) {
          String dbHiraganaAsRomaji = kanaKit.toRomaji(
            item.character.trim().replaceAll(" ", ""),
          );

          if (dbHiraganaAsRomaji == expected) {
            heard = expected;
            print(
              "DEBUG KANNA -> Kanji '$spoken' sukses dicocokkan dengan Hiragana DB via Romaji Match!",
            );
            break;
          }
        }
      }
    }

    print("DEBUG KANNA -> Target: $expected | Didengar: $heard");

    if (expected == heard || heard.contains(expected)) {
      score.value = 100.0;
    } else {
      double similarity = expected.similarityTo(heard);
      score.value = similarity * 100;
    }
  }

  String getRomajiResult(String targetRomaji) {
    if (score.value <= 0 || recognizedText.value.isEmpty) return "";

    String expected = targetRomaji.trim().toLowerCase().replaceAll(" ", "");

    if (score.value >= 90) {
      return expected;
    }

    String result = normalizeSpeech(recognizedText.value);

    if (!kanaKit.isRomaji(result)) {
      return "";
    }

    return result;
  }
Future<void> loadData(
  String endpoint,
  RxList<SpeechItem> target,
) async {
  try {
    final response = await dio.get("$baseUrl/$endpoint");

    final List data = response.data["data"];

    target.assignAll(
      data.map((e) => SpeechItem.fromJson(e)).toList(),
    );
  } catch (e) {
    print("ERROR $endpoint => $e");
  }
}
  List<SpeechItem> get currentData {
    switch (selectedIndex.value) {
      case 0:
        return numbers;
      case 1:
        return months;
      case 2:
        return dates;
      case 3:
        return family;
      case 4:
        return animals;
      case 5:
        return foods;
      case 6:
        return drinks;
      case 7:
        return jobs;
      case 8:
        return objects;
      default:
        return numbers;
    }
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  /// =========================
  /// SPEECH
  /// =========================

  Future<void> startListening(String target) async {
    bool available = await speech.initialize();

    if (!available) return;

    recognizedText.value = "";
    score.value = 0;

    isListening.value = true;

    await speech.listen(
      localeId: "ja_JP",
      partialResults: true,
      listenFor: const Duration(seconds: 5),
      pauseFor: const Duration(seconds: 3),
      onResult: (result) {
        recognizedText.value = result.recognizedWords;
        calculateScore(target, recognizedText.value);
      },
    );

    Future.delayed(const Duration(seconds: 6), () {
      if (isListening.value) {
        stopListening(target);
      }
    });
  }

  Future<void> stopListening(String target) async {
    await speech.stop();

    isListening.value = false;

    if (recognizedText.value.trim().isEmpty) {
      clearResult();
      return;
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      showResultDialog(target);
    });
  }

  void toggleMic(String target) {
    if (isListening.value) {
      stopListening(target);
    } else {
      startListening(target);
    }
  }

  void clearResult() {
    recognizedText.value = "";
    score.value = 0;
  }

  // =========================
  /// RESULT POPUP
  /// =========================
  void showResultDialog(String targetRomaji) {
    String message;

    if (score.value == 0) {
      message = "Pelafalan Tidak Sesuai";
    } else if (score.value < 60) {
      message = "Pelafalan Kurang Sesuai";
    } else if (score.value < 90) {
      message = "Hampir Benar";
    } else {
      message = "Pelafalan Bagus!";
    }

    String popupRomajiResult = getRomajiResult(targetRomaji);
    SpeechItem? selectedItem;

    final allItems = [
      ...numbers,
      ...months,
      ...dates,
      ...family,
      ...animals,
      ...foods,
      ...drinks,
      ...jobs,
      ...objects,
    ];

    try {
      selectedItem = allItems.firstWhere(
        (e) =>
            e.romaji.trim().toLowerCase() == targetRomaji.trim().toLowerCase(),
      );
    } catch (_) {}

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                score.value >= 80 ? Icons.check_circle : Icons.graphic_eq,
                color: score.value >= 80 ? Colors.green : Colors.red,
                size: 80,
              ),

              const SizedBox(height: 16),

              if (score.value > 0)
                Text(
                  "${score.value.toStringAsFixed(0)}%",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: score.value >= 80 ? Colors.green : Colors.red,
                  ),
                ),

              const SizedBox(height: 10),

              Text(message, style: const TextStyle(color: Colors.grey)),
              if (score.value > 0 && popupRomajiResult.isNotEmpty) ...[
                const SizedBox(
                  height: 12,
                ), // Jarak diatur sedikit lebih longgar agar rapi
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                    ), // <--- Mengatur seluruh anak teks menjadi miring bersamaan
                    children: [
                      const TextSpan(
                        text: "Hasil: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey, // Label "Hasil:" diatur abu-abu
                        ),
                      ),
                      TextSpan(
                        text: popupRomajiResult,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors
                              .black87, // Hasil teks romajinya tetap hitam pekat
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final isSuccess = score.value >= 90;

                    if (isSuccess) {
                      final box = GetStorage();
                      final userId = box.read('userId');

                      if (userId != null) {
                        await ApiService.saveActivity(
                          userId: userId,
                          activityType: "pronunciation",
                          title: "Latihan Pelafalan",
                          detail: selectedItem != null
                              ? "${selectedItem.character} - ${selectedItem.romaji} (${selectedItem.meaning})"
                              : targetRomaji,
                          score: score.value.toInt(),
                        );
                      }

                      Get.back();
                      Get.back();
                    } else {
                      Get.back();
                    }

                    clearResult();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (score.value >= 90)
                        ? Colors.green
                        : Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: Text((score.value >= 90) ? "Selesai" : "Coba Lagi"),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
