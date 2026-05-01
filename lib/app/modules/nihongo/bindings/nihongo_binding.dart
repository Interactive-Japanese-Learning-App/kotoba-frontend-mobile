import 'package:get/get.dart';
import '../controllers/nihongo_controller.dart';

class NihongoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NihongoController>(() => NihongoController());
  }
}