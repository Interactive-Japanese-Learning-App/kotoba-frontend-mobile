import 'package:get/get.dart';
import '../controllers/pelafalan_controller.dart';

class PelafalanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PelafalanController>(() => PelafalanController());
  }
}