import 'package:get/get.dart';
import '../controllers/membaca1_controller.dart';

class Membaca1Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Membaca1Controller>(
      () => Membaca1Controller(),
    );
  }
}