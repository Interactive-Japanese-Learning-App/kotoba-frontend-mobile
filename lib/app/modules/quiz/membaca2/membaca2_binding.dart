import 'package:get/get.dart';
import 'membaca2_controller.dart';

class Membaca2Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Membaca2Controller>(() => Membaca2Controller());
  }
}