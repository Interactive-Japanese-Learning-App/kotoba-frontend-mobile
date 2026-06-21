import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:dio/dio.dart';

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

  static const String baseUrl = "http://192.168.18.9:5000/api/nihongo";
  @override
  void onInit() {
    super.onInit();

    loadData("numbers", numbers);
    loadData("months", months);
    loadData("dates", dates);
    loadData("family", family);
    loadData("animals", animals);
    loadData("foods", foods);
    loadData("drinks", drinks);
    loadData("jobs", jobs);
    loadData("object_vocab", objects);

    initSpeech();
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
    text = text.toLowerCase().trim();
    final specialMap = {
      // KELUARGA
      "かぞく": "kazoku",
      "家族": "kazoku",

      "ちち": "chichi",
      "父": "chichi",

      "はは": "haha",
      "母": "haha",

      "りょうしん": "ryoushin",
      "両親": "ryoushin",

      "あに": "ani",
      "兄": "ani",

      "あね": "ane",
      "姉": "ane",

      "おとうと": "otouto",
      "弟": "otouto",

      "いもうと": "imouto",
      "妹": "imouto",

      // HEWAN
      "いぬ": "inu",
      "犬": "inu",

      "ねこ": "neko",
      "猫": "neko",

      "とり": "tori",
      "鳥": "tori",

      "さかな": "sakana",
      "魚": "sakana",

      "うま": "uma",
      "馬": "uma",

      "うし": "ushi",
      "牛": "ushi",

      // MAKANAN
      "ごはん": "gohan",
      "ご飯": "gohan",

      "すし": "sushi",
      "寿司": "sushi",

      "たまご": "tamago",
      "卵": "tamago",

      "にく": "niku",
      "肉": "niku",

      "やさい": "yasai",
      "野菜": "yasai",

      "くだもの": "kudamono",
      "果物": "kudamono",

      "りんご": "ringo",
      "林檎": "ringo",

      // MINUMAN
      "みず": "mizu",
      "水": "mizu",

      "おちゃ": "ocha",
      "お茶": "ocha",

      "ぎゅうにゅう": "gyuunyuu",
      "牛乳": "gyuunyuu",

      "こうちゃ": "koucha",
      "紅茶": "koucha",

      "りょくちゃ": "ryokucha",
      "緑茶": "ryokucha",

      "とうにゅう": "tounyuu",
      "豆乳": "tounyuu",

      // PEKERJAAN
      "センセイ": "sensei",
      "せんせい": "sensei",
      "先生": "sensei",

      "イシャ": "isha",
      "いしゃ": "isha",
      "医者": "isha",

      "ガクセイ": "gakusei",
      "がくせい": "gakusei",
      "学生": "gakusei",

      "ケイサツ": "keisatsu",
      "けいさつ": "keisatsu",
      "警察": "keisatsu",

      // BENDA
      "つくえ": "tsukue",
      "机": "tsukue",

      "いす": "isu",
      "椅子": "isu",

      "ほん": "hon",
      "本": "hon",

      "えんぴつ": "enpitsu",
      "鉛筆": "enpitsu",

      "かばん": "kaban",
      "鞄": "kaban",

      "とけい": "tokei",
      "時計": "tokei",

      "まど": "mado",
      "窓": "mado",

      "でんわ": "denwa",
      "電話": "denwa",

      "れいぞうこ": "reizouko",
      "冷蔵庫": "reizouko",

      "くつ": "kutsu",
      "靴": "kutsu",

      "ふく": "fuku",
      "服": "fuku",

      "かさ": "kasa",
      "傘": "kasa",

      "こくばん": "kokuban",
      "黒板": "kokuban",

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
    final allWords = [
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
    for (final item in allWords) {
      final character = item.character.trim().toLowerCase();
      final romaji = item.romaji.trim().toLowerCase();

      if (text == character) {
        print("MATCH CHARACTER => $character -> $romaji");
        return romaji;
      }

      if (text == romaji) {
        print("MATCH ROMAJI => $romaji");
        return romaji;
      }
    }

    // baru cek special map
    if (specialMap.containsKey(text)) {
      return specialMap[text]!;
    }

    return text;
  }

  String getRomajiResult() {
    if (score.value <= 0) {
      return "";
    }

    return normalizeSpeech(recognizedText.value);
  }

  Future<void> loadData(String endpoint, RxList<SpeechItem> target) async {
    try {
      final response = await dio.get("$baseUrl/$endpoint");

      final List data = response.data["data"];

      target.assignAll(data.map((e) => SpeechItem.fromJson(e)).toList());
    } catch (e) {
      print(e);
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

    // kalau tidak ada suara sama sekali, langsung keluar
    if (recognizedText.value.trim().isEmpty) {
      clearResult();
      return;
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      showResultDialog();
    });
  }

  void calculateScore(String target, String spoken) {
    if (spoken.isEmpty) {
      score.value = 0;
      return;
    }

    print("RAW TARGET : $target");
    print("RAW SPOKEN : $spoken");

    String expected = normalizeSpeech(target);
    String heard = normalizeSpeech(spoken);

    print("NORMAL TARGET : $expected");
    print("NORMAL HEARD : $heard");

    expected = expected.toLowerCase().trim();
    heard = heard.toLowerCase().trim();

    expected = expected.replaceAll(" ", "");
    heard = heard.replaceAll(" ", "");

    double similarity = expected.similarityTo(heard);

    score.value = similarity * 100;

    print("SCORE : ${score.value}");
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

  /// =========================
  /// RESULT POPUP
  /// =========================
  void showResultDialog() {
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

              if (score.value > 0) ...[
                const SizedBox(height: 10),

                Text(
                  getRomajiResult(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final isSuccess = score.value >= 90;

                    clearResult();

                    if (isSuccess) {
                      Get.back();
                      Get.back();
                    } else {
                      Get.back();
                    }
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
