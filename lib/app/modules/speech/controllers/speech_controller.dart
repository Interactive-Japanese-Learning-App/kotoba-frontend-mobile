import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SpeechController extends GetxController {
  final selectedIndex = 0.obs;

  final isListening = false.obs;

  final recognizedText = "".obs;

  final score = 0.0.obs;

  final SpeechToText speech = SpeechToText();
  final FlutterTts tts = FlutterTts();

  @override
  void onInit() {
    super.onInit();
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

  /// =========================
  /// DATA
  /// =========================
  final List<Map<String, String>> numbers = [
    {'label': 'ichi', 'kana': 'いち', 'display': '一', 'indo': 'Satu'},
    {'label': 'ni', 'kana': 'に', 'display': '二', 'indo': 'Dua'},
    {'label': 'san', 'kana': 'さん', 'display': '三', 'indo': 'Tiga'},
    {'label': 'yon', 'kana': 'よん', 'display': '四', 'indo': 'Empat'},
    {'label': 'go', 'kana': 'ご', 'display': '五', 'indo': 'Lima'},
    {'label': 'roku', 'kana': 'ろく', 'display': '六', 'indo': 'Enam'},
    {'label': 'nana', 'kana': 'なな', 'display': '七', 'indo': 'Tujuh'},
    {'label': 'hachi', 'kana': 'はち', 'display': '八', 'indo': 'Delapan'},
    {'label': 'kyuu', 'kana': 'きゅう', 'display': '九', 'indo': 'Sembilan'},
    {'label': 'juu', 'kana': 'じゅう', 'display': '十', 'indo': 'Sepuluh'},
  ];

  final List<Map<String, String>> months = [
    {'label': 'ichigatsu', 'kana': 'いちがつ', 'display': '一月', 'indo': 'Januari'},
    {'label': 'nigatsu', 'kana': 'にがつ', 'display': '二月', 'indo': 'Februari'},
    {'label': 'sangatsu', 'kana': 'さんがつ', 'display': '三月', 'indo': 'Maret'},
    {'label': 'shigatsu', 'kana': 'しがつ', 'display': '四月', 'indo': 'April'},
    {'label': 'gogatsu', 'kana': 'ごがつ', 'display': '五月', 'indo': 'Mei'},
    {'label': 'rokugatsu', 'kana': 'ろくがつ', 'display': '六月', 'indo': 'Juni'},
    {'label': 'shichigatsu', 'kana': 'しちがつ', 'display': '七月', 'indo': 'Juli'},
    {'label': 'hachigatsu', 'kana': 'はちがつ', 'display': '八月', 'indo': 'Agustus'},
    {'label': 'kugatsu', 'kana': 'くがつ', 'display': '九月', 'indo': 'September'},
    {'label': 'juugatsu', 'kana': 'じゅうがつ', 'display': '十月', 'indo': 'Oktober'},
    {
      'label': 'juuichigatsu',
      'kana': 'じゅういちがつ',
      'display': '十一月',
      'indo': 'November',
    },
    {
      'label': 'juunigatsu',
      'kana': 'じゅうにがつ',
      'display': '十二月',
      'indo': 'Desember',
    },
  ];

  final List<Map<String, String>> dates = [
    {
      'label': 'tsuitachi',
      'kana': 'ついたち',
      'display': '一日',
      'indo': 'Tanggal 1',
    },
    {'label': 'futsuka', 'kana': 'ふつか', 'display': '二日', 'indo': 'Tanggal 2'},
    {'label': 'mikka', 'kana': 'みっか', 'display': '三日', 'indo': 'Tanggal 3'},
    {'label': 'yokka', 'kana': 'よっか', 'display': '四日', 'indo': 'Tanggal 4'},
    {'label': 'itsuka', 'kana': 'いつか', 'display': '五日', 'indo': 'Tanggal 5'},
    {'label': 'muika', 'kana': 'むいか', 'display': '六日', 'indo': 'Tanggal 6'},
    {'label': 'nanoka', 'kana': 'なのか', 'display': '七日', 'indo': 'Tanggal 7'},
    {'label': 'youka', 'kana': 'ようか', 'display': '八日', 'indo': 'Tanggal 8'},
    {'label': 'kokonoka', 'kana': 'ここのか', 'display': '九日', 'indo': 'Tanggal 9'},
    {'label': 'tooka', 'kana': 'とおか', 'display': '十日', 'indo': 'Tanggal 10'},
  ];

  final List<Map<String, String>> family = [
    {'label': 'kazoku', 'kana': 'かぞく', 'display': '家族', 'indo': 'Keluarga'},
    {'label': 'chichi', 'kana': 'ちち', 'display': '父', 'indo': 'Ayah'},
    {'label': 'haha', 'kana': 'はは', 'display': '母', 'indo': 'Ibu'},
    {
      'label': 'ryoushin',
      'kana': 'りょうしん',
      'display': '両親',
      'indo': 'Orang Tua',
    },
    {'label': 'ani', 'kana': 'あに', 'display': '兄', 'indo': 'Kakak Laki-laki'},
    {'label': 'ane', 'kana': 'あね', 'display': '姉', 'indo': 'Kakak Perempuan'},
    {
      'label': 'otouto',
      'kana': 'おとうと',
      'display': '弟',
      'indo': 'Adik Laki-laki',
    },
    {
      'label': 'imouto',
      'kana': 'いもうと',
      'display': '妹',
      'indo': 'Adik Perempuan',
    },
    {'label': 'sofu', 'kana': 'そふ', 'display': '祖父', 'indo': 'Kakek'},
    {'label': 'sobo', 'kana': 'そぼ', 'display': '祖母', 'indo': 'Nenek'},
  ];
  final List<Map<String, String>> animals = [
    {'label': 'inu', 'kana': 'いぬ', 'display': '犬', 'indo': 'Anjing'},
    {'label': 'neko', 'kana': 'ねこ', 'display': '猫', 'indo': 'Kucing'},
    {'label': 'tori', 'kana': 'とり', 'display': '鳥', 'indo': 'Burung'},
    {'label': 'sakana', 'kana': 'さかな', 'display': '魚', 'indo': 'Ikan'},
    {'label': 'uma', 'kana': 'うま', 'display': '馬', 'indo': 'Kuda'},
    {'label': 'ushi', 'kana': 'うし', 'display': '牛', 'indo': 'Sapi'},
    {'label': 'buta', 'kana': 'ぶた', 'display': '豚', 'indo': 'Babi'},
    {'label': 'hitsuji', 'kana': 'ひつじ', 'display': '羊', 'indo': 'Domba'},
    {'label': 'saru', 'kana': 'さる', 'display': '猿', 'indo': 'Monyet'},
    {'label': 'usagi', 'kana': 'うさぎ', 'display': '兎', 'indo': 'Kelinci'},
  ];
  final List<Map<String, String>> foods = [
    {'label': 'gohan', 'kana': 'ごはん', 'display': 'ご飯', 'indo': 'Nasi'},
    {'label': 'pan', 'kana': 'パン', 'display': 'パン', 'indo': 'Roti'},
    {'label': 'sushi', 'kana': 'すし', 'display': '寿司', 'indo': 'Sushi'},
    {'label': 'raamen', 'kana': 'ラーメン', 'display': 'ラーメン', 'indo': 'Ramen'},
    {'label': 'udon', 'kana': 'うどん', 'display': 'うどん', 'indo': 'Udon'},
    {'label': 'soba', 'kana': 'そば', 'display': 'そば', 'indo': 'Soba'},
    {'label': 'tamago', 'kana': 'たまご', 'display': '卵', 'indo': 'Telur'},
    {'label': 'niku', 'kana': 'にく', 'display': '肉', 'indo': 'Daging'},
    {'label': 'yasai', 'kana': 'やさい', 'display': '野菜', 'indo': 'Sayur'},
    {'label': 'kudamono', 'kana': 'くだもの', 'display': '果物', 'indo': 'Buah'},
  ];
  final List<Map<String, String>> drinks = [
    {'label': 'mizu', 'kana': 'みず', 'display': '水', 'indo': 'Air'},
    {'label': 'ocha', 'kana': 'おちゃ', 'display': 'お茶', 'indo': 'Teh'},
    {'label': 'gyuunyuu', 'kana': 'ぎゅうにゅう', 'display': '牛乳', 'indo': 'Susu'},
    {'label': 'koohii', 'kana': 'コーヒー', 'display': 'コーヒー', 'indo': 'Kopi'},
    {'label': 'juusu', 'kana': 'ジュース', 'display': 'ジュース', 'indo': 'Jus'},
    {'label': 'koucha', 'kana': 'こうちゃ', 'display': '紅茶', 'indo': 'Teh Hitam'},
    {
      'label': 'remoneedo',
      'kana': 'レモネード',
      'display': 'レモネード',
      'indo': 'Limun',
    },
    {'label': 'koora', 'kana': 'コーラ', 'display': 'コーラ', 'indo': 'Cola'},
  ];
  final List<Map<String, String>> jobs = [
    {'label': 'sensei', 'kana': 'せんせい', 'display': '先生', 'indo': 'Guru'},
    {'label': 'isha', 'kana': 'いしゃ', 'display': '医者', 'indo': 'Dokter'},
    {'label': 'gakusei', 'kana': 'がくせい', 'display': '学生', 'indo': 'Pelajar'},
    {'label': 'keisatsu', 'kana': 'けいさつ', 'display': '警察', 'indo': 'Polisi'},
    {'label': 'kangoshi', 'kana': 'かんごし', 'display': '看護師', 'indo': 'Perawat'},
    {
      'label': 'kaishain',
      'kana': 'かいしゃいん',
      'display': '会社員',
      'indo': 'Pegawai',
    },
    {'label': 'nouka', 'kana': 'のうか', 'display': '農家', 'indo': 'Petani'},
    {'label': 'ryourinin', 'kana': 'りょうりにん', 'display': '料理人', 'indo': 'Koki'},
    {'label': 'untenshu', 'kana': 'うんてんしゅ', 'display': '運転手', 'indo': 'Supir'},
    {'label': 'kashu', 'kana': 'かしゅ', 'display': '歌手', 'indo': 'Penyanyi'},
  ];
  final List<Map<String, String>> objects = [
    {'label': 'tsukue', 'kana': 'つくえ', 'display': '机', 'indo': 'Meja'},
    {'label': 'isu', 'kana': 'いす', 'display': '椅子', 'indo': 'Kursi'},
    {'label': 'hon', 'kana': 'ほん', 'display': '本', 'indo': 'Buku'},
    {'label': 'enpitsu', 'kana': 'えんぴつ', 'display': '鉛筆', 'indo': 'Pensil'},
    {
      'label': 'keshigomu',
      'kana': 'けしごむ',
      'display': '消しゴム',
      'indo': 'Penghapus',
    },
    {'label': 'kaban', 'kana': 'かばん', 'display': '鞄', 'indo': 'Tas'},
    {'label': 'tokei', 'kana': 'とけい', 'display': '時計', 'indo': 'Jam'},
    {'label': 'mado', 'kana': 'まど', 'display': '窓', 'indo': 'Jendela'},
    {'label': 'doa', 'kana': 'ドア', 'display': 'ドア', 'indo': 'Pintu'},
    {'label': 'terebi', 'kana': 'テレビ', 'display': 'テレビ', 'indo': 'Televisi'},
  ];

  String normalizeSpeech(String text) {
    text = text.toLowerCase().trim();

    final specialMap = {
      // angka
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

      // bulan
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

      // tanggal
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
    };

    if (specialMap.containsKey(text)) {
      return specialMap[text]!;
    }
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
      if (text == item["kana"] || text == item["display"]) {
        return item["label"]!;
      }
    }

    return text;
  }

  String getRomajiResult() {
    if (score.value <= 0) {
      return "";
    }

    return normalizeSpeech(recognizedText.value);
  }

  List<Map<String, String>> get currentData {
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
  }

  Future<void> stopListening(String target) async {
    await speech.stop();

    isListening.value = false;

    Future.delayed(const Duration(milliseconds: 500), () {
      showResultDialog();
    });
  }

  void calculateScore(String target, String spoken) {
    if (spoken.isEmpty) {
      score.value = 0;
      return;
    }

    String expected = target.toLowerCase().trim();

    String heard = normalizeSpeech(spoken);

    expected = expected.replaceAll(" ", "");
    expected = expected.replaceAll("ー", "");

    heard = heard.replaceAll(" ", "");
    heard = heard.replaceAll("ー", "");

    double similarity = expected.similarityTo(heard);

    score.value = similarity * 100;

    if (score.value < 40) {
      score.value = 0;
    }
    print("TARGET : $expected");
    print("HEARD  : $heard");
    print("SCORE  : ${score.value}");
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
    bool noSpeech = recognizedText.value.trim().isEmpty;
    String message;

    if (noSpeech) {
      message = "Suara tidak terdeteksi";
    } else if (score.value == 0) {
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
                noSpeech
                    ? Icons.mic_off
                    : (score.value >= 80
                          ? Icons.check_circle
                          : Icons.graphic_eq),
                color: noSpeech
                    ? Colors.red
                    : (score.value >= 80 ? Colors.green : Colors.red),
                size: 80,
              ),

              const SizedBox(height: 16),

              if (!noSpeech && score.value > 0)
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

              if (!noSpeech) ...[
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
                    final isSuccess = !noSpeech && score.value >= 90;

                    clearResult();

                    if (isSuccess) {
                      Get.back();
                      Get.back();
                    } else {
                      Get.back();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (!noSpeech && score.value >= 90)
                        ? Colors.green
                        : Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    (!noSpeech && score.value >= 90) ? "Selesai" : "Coba Lagi",
                  ),
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
