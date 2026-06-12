import 'package:get/get.dart';
import '../../../data/theme/app_colors.dart';

class QuizController extends GetxController {
  /// DATA QUIZ
  final sections = [
    {
      "title": "Hiragana",
      "icon": "あ",
      "color": AppColors.danger,
      "levels": [true, true, true, true, true],
    },
    {
      "title": "Katakana",
      "icon": "ア",
      "color": AppColors.primary,
      "levels": [true, true, false, false, false],
    },
  ];

  /// QUIZ LOGIC
  var totalSoal = 5;
  var benar = 0.obs;
  var currentIndex = 0.obs;

  /// XP SYSTEM
  var xp = 0.obs;
  var xpPerSoal = 20;

  int get maxXp => totalSoal * xpPerSoal;

  void tambahBenar() {
    benar.value++;
    xp.value += xpPerSoal;
  }

  void jawab({required bool isBenar}) {
    if (isBenar) tambahBenar();
    nextSoal();
  }

  void nextSoal() {
    if (currentIndex.value < totalSoal - 1) {
      currentIndex.value++;
    }
  }

  /// PROGRESS
  double get progress => maxXp == 0 ? 0 : xp.value / maxXp;

  double get accuracy => totalSoal == 0 ? 0 : (benar.value / totalSoal) * 100;

  /// FIX ERROR PERSEN
  int get persen => maxXp == 0 ? 0 : ((xp.value / maxXp) * 100).toInt();

  /// RESET
  void resetQuiz() {
    benar.value = 0;
    currentIndex.value = 0;
    xp.value = 0;
    pelafalanAccuracy.value = 0;
  }

  /// PELAFALAN
  var pelafalanAccuracy = 0.0.obs;

  void setPelafalanAccuracy(double value) {
    pelafalanAccuracy.value = value;
  }
}
