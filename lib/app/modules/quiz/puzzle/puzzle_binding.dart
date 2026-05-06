import 'package:get/get.dart';
import 'package:kotoba_app/app/modules/quiz/puzzle/puzzle_controller.dart';

class QuizPuzzleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PuzzleController>(() => PuzzleController());
  }
}