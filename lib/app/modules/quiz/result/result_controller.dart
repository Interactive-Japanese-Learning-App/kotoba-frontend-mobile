import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../quiz/quiz_controller.dart';

class ResultController extends GetxController {
  final quizC = Get.find<QuizController>();

  int get xp => quizC.xp.value;
  int get maxXp => quizC.maxXp;
  int get persen => quizC.persen;
  double get progress => quizC.progress;

  int get benar => quizC.benar.value;
  int get total => quizC.totalSoal;

  double get accuracy => quizC.pelafalanAccuracy.value;

  void ulangQuiz() {
    quizC.resetQuiz();
    Get.offAllNamed(Routes.QUIZ);
  }

  void keHome() {
    quizC.resetQuiz();
    Get.offAllNamed(Routes.QUIZ);
  }
}