import 'package:get/get.dart';
import '../controllers/menulis_controller.dart';

class MenulisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenulisController>(() => MenulisController());
  }
}