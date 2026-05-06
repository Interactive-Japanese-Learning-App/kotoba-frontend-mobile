import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class LearnController extends GetxController {

  /// NAVIGASI
  void goToNihongo() {
    Get.toNamed(Routes.NIHONGO);
  }

  void goToWriting() {
    Get.toNamed(Routes.WRITING);
  }

  void goToSpeech() {
    Get.toNamed(Routes.SPEECH);
  }

  void goToQuiz() {
    Get.toNamed(Routes.QUIZ);
  }
}