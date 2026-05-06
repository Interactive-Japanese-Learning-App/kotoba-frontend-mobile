import 'package:get/get.dart';
import 'membaca1_controller.dart';

class Membaca1Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Membaca1Controller>(
      () => Membaca1Controller(),
    );
  }
}