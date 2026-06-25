import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../quiz/quiz_controller.dart';
import '../../home/controllers/home_controller.dart';

class ResultController extends GetxController {
  final quizC = Get.find<QuizController>();

  /// XP dari progress backend
  int get xp => quizC.xp;

  int get maxXp => quizC.maxXp;

  RxInt get benar => quizC.benar;

  int get total => quizC.totalSoal;

  RxDouble get accuracy => quizC.pelafalanAccuracy;

  double get progress {
    if (maxXp == 0) return 0;
    return xp / maxXp;
  }

  int get persen => (progress * 100).toInt();

  /// Ulang quiz
  void ulangQuiz() {
    quizC.resetQuiz();

    Get.offAllNamed(
      Routes.QUIZ,
    );
  }

  /// Kembali ke home
  Future<void> keHome() async {
    quizC.resetQuiz();

    if (Get.isRegistered<HomeController>()) {
      await Get.find<HomeController>().loadProfile();
    }

    Get.offAllNamed(
      Routes.MAIN,
    );
  }
}