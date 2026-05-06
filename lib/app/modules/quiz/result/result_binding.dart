import 'package:get/get.dart';
import 'package:kotoba_app/app/modules/quiz/result/result_controller.dart';


class ResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResultController>(() => ResultController());
  }
}