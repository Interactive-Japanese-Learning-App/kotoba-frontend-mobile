import 'package:get/get.dart';
import 'menulis_controller.dart';

class MenulisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenulisController>(() => MenulisController());
  }
}