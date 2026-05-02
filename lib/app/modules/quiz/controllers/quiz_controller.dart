import 'package:get/get.dart';
import '../../../data/theme/app_colors.dart';
import '../../../routes/app_pages.dart';

class QuizController extends GetxController {
  /// 🔥 DATA QUIZ
  final sections = [
    {
      "title": "Hiragana",
      "icon": "あ",
      "color": AppColors.danger,

      /// status unlock
      "levels": [true, false, false, false, false],
    },

    {
      "title": "Katakana",
      "icon": "ア",
      "color": AppColors.primary,

      "levels": [true, true, false, false, false],
    },
  ];

  /// 🔥 KE HALAMAN SOAL
  void goToQuestion() {
    Get.toNamed(Routes.QUIZ_QUESTION);
  }
}
