import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kotoba_app/app/data/services/api_service.dart';
import 'package:kotoba_app/app/modules/quiz/quiz/quiz_controller.dart';
import 'package:kotoba_app/app/routes/app_pages.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:string_similarity/string_similarity.dart';

class PelafalanController extends GetxController {
  final isLoading = true.obs;
  final question = Rxn<Map<String, dynamic>>();
  final FlutterTts tts = FlutterTts();
  final box = GetStorage();

  late String sectionId;
  late String sectionTitle;
  late int questionNo;

  final isListening = false.obs;
  final SpeechToText speech = SpeechToText();

  final recognizedText =
      "".obs; // Menampung hasil teks Jepang asli dari STT (Kanji/Kana)
  final convertedRomajiResult =
      "".obs; // Menampung hasil konversi Romaji bersih / Pesan Latin
  final score = 0.0.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};
    sectionId = (args["sectionId"] ?? "").toString();
    sectionTitle = (args["sectionTitle"] ?? "").toString();

    final qNo = args["questionNo"] ?? args["question_no"] ?? 5;
    questionNo = int.tryParse(qNo.toString()) ?? 5;

    initSpeech();

    if (sectionId.isNotEmpty) {
      loadQuestionData();
    } else {
      isLoading.value = false;
    }
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

  void toggleMic(String targetKana, String targetRomaji) {
    if (isListening.value) {
      stopListening(targetKana, targetRomaji);
    } else {
      startListening(targetKana, targetRomaji);
    }
  }

  Future<void> startListening(String targetKana, String targetRomaji) async {
    bool available = await speech.initialize();
    if (!available) return;

    // Bersihkan layar total saat tombol mic kembali ditekan (mulai rekam baru)
    recognizedText.value = "";
    convertedRomajiResult.value = "";
    score.value = 0;
    isListening.value = true;

    await speech.listen(
      localeId: "ja_JP",
      partialResults: true,
      listenFor: const Duration(seconds: 6),
      pauseFor: const Duration(
        seconds: 2,
      ), // Dipercepat dari 3 ke 2 detik untuk deteksi jeda diam
      onResult: (result) {
        recognizedText.value = result.recognizedWords;
        print("Hasil Live STT Asli: ${result.recognizedWords}");

        calculateScore(targetKana, targetRomaji, result.recognizedWords);
      },
    );

    Future.delayed(const Duration(seconds: 7), () {
      if (isListening.value) {
        stopListening(targetKana, targetRomaji);
      }
    });
  }

  Future<void> stopListening(String targetKana, String targetRomaji) async {
    await speech.stop();
    isListening.value =
        false; // Tombol mic langsung seketika berubah jadi BIRU di UI

    // Jika salah atau di bawah target kelulusan (80%)
    if (recognizedText.value.trim().isEmpty || score.value < 80) {
      score.value = 0;
      convertedRomajiResult.value = "Pelafalan kurang tepat";

      // Menggunakan durasi 1.5 detik agar tulisan merah menghilang lebih cepat dari sebelumnya
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (!isListening.value &&
            convertedRomajiResult.value == "Pelafalan kurang tepat") {
          convertedRomajiResult.value = "";
        }
      });
      return;
    }

    // Dipanggil hanya jika pelafalan sukses telak (>= 80)
    Future.delayed(const Duration(milliseconds: 200), () {
      showResultDialog(targetRomaji);
    });
  }

  String cleanText(String text) {
    return text
        .toLowerCase()
        .trim()
        .replaceAll(".", "")
        .replaceAll("。", "")
        .replaceAll(",", "")
        .replaceAll("、", "")
        .replaceAll(" ", "")
        .replaceAll("ー", "");
  }

  String matchSpeechToRomaji(
    String spoken,
    String targetKana,
    String targetRomaji,
  ) {
    String cleanSpoken = cleanText(spoken);
    String cleanTargetKana = cleanText(targetKana);
    String cleanTargetRomaji = targetRomaji.toLowerCase().trim();

    if (cleanTargetRomaji == "gohan") {
      final validGohanMatches = [
        "gohan",
        "ごはん",
        "ご飯",
        "お飯",
        "ごはん gga",
        "ごはん を",
      ];
      if (validGohanMatches.contains(cleanSpoken)) {
        return "gohan";
      }
    }

    if (cleanSpoken == cleanTargetKana) {
      return cleanTargetRomaji;
    }

    double visualSimilarity = cleanTargetKana.similarityTo(cleanSpoken);
    if (visualSimilarity > 0.85) {
      return cleanTargetRomaji;
    }

    return "";
  }

  // Ubah bagian ini di dalam void calculateScore
  void calculateScore(String targetKana, String targetRomaji, String spoken) {
    if (spoken.isEmpty) {
      score.value = 0;
      return;
    }

    String heardRomaji = matchSpeechToRomaji(spoken, targetKana, targetRomaji);
    String expected = cleanText(targetRomaji);
    String heard = cleanText(heardRomaji);

    if (expected == "gohan" && (heard == "ご飯" || heard == "ごはん")) {
      heard = "gohan";
    }

    if (heard.isEmpty) {
      score.value = 0;
      // Cukup update teksnya saja, biarkan fungsi stopListening yang mengurus sisanya
      convertedRomajiResult.value = "Pelafalan kurang tepat";

      // HAPUS pemanggilan stopListening(targetKana, targetRomaji); di sini
      // agar tidak terjadi tumpang tindih (double call)
    } else {
      convertedRomajiResult.value = heard;
      double similarity = expected.similarityTo(heard);
      score.value = similarity * 100;
    }

    // Jika skor sudah cukup, baru hentikan
    if (score.value >= 80 && isListening.value) {
      stopListening(targetKana, targetRomaji);
    }
  }

  void clearResult() {
    recognizedText.value = "";
    convertedRomajiResult.value = "";
    score.value = 0;
  }

  Future<void> loadQuestionData() async {
    try {
      isLoading.value = true;
      final response = await ApiService.getQuizQuestions(sectionId);

      if (response["success"] == true) {
        final questions = response["data"] as List;
        final found = questions.where((e) {
          final no = e["questionNo"];
          if (no == null) return false;
          return int.tryParse(no.toString()) == questionNo;
        }).toList();

        if (found.isNotEmpty) {
          question.value = found.first;
          questionNo =
              int.tryParse(found.first["questionNo"].toString()) ?? questionNo;
        } else if (questions.isNotEmpty) {
          question.value = questions.first;
          final q = questions.first["questionNo"];
          questionNo = int.tryParse(q.toString()) ?? questionNo;
        }
      }
    } catch (e) {
      print("Load Pelafalan Question Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void showResultDialog(String fallbackRomaji) {
    String message = "Pelafalan Bagus!";
    final isSuccess = score.value >= 80;

    String displayRomaji = convertedRomajiResult.value.trim();
    if (displayRomaji.isEmpty ||
        displayRomaji == "Pelafalan kurang tepat" ||
        (isSuccess && displayRomaji != fallbackRomaji.toLowerCase().trim())) {
      displayRomaji = fallbackRomaji.toLowerCase().trim();
    }

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
              Text(
                "${score.value.toStringAsFixed(0)}%",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              if (displayRomaji.isNotEmpty) ...[
                const SizedBox(height: 15),
                const Text(
                  "Suara kamu terdeteksi sebagai:",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),

                Text.rich(
                  TextSpan(
                    style: const TextStyle(fontStyle: FontStyle.italic),
                    children: [
                      const TextSpan(
                        text: "Hasil: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                        text: displayRomaji,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (isSuccess) ...[
                const SizedBox(height: 8),
                const Text(
                  "Semua soal telah selesai!",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],

              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    clearResult();

                    if (isSuccess) {
                      final quizC = Get.find<QuizController>();

                      quizC.setPelafalanAccuracy(score.value);

                      quizC.jawab(isBenar: true);

                      await quizC.refreshProgress();

                      Get.back();

                      Get.offNamed(Routes.QUIZ_RESULT);
                    } else {
                      Get.back();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSuccess
                        ? Colors.green
                        : Colors.red, // Warna dinamis lolos/gagal
                    foregroundColor: Colors.white,
                    elevation: 2,
                  ),
                  child: Text(isSuccess ? "Lihat Hasil" : "Coba Lagi"),
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
