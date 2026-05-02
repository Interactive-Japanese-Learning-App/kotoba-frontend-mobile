import 'package:get/get.dart';
import '../../../data/theme/app_colors.dart';

class QuizController extends GetxController {
  /// 🔥 DATA QUIZ
  final sections = [
    {
      "title": "Hiragana",
      "icon": "あ",
      "color": AppColors.danger,

      /// status unlock
      "levels": [true, true, true, true, true ],
    },

    {
      "title": "Katakana",
      "icon": "ア",
      "color": AppColors.primary,

      "levels": [true, true, false, false, false],
    },
  ];
}