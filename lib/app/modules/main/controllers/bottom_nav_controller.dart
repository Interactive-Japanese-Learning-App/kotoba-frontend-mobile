import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';

class BottomNavController extends GetxController {
  var currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;

    if (index == 0 && Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().loadProfile();
    }
  }

  void goToCamera() {
    currentIndex.value = 1;
  }
}
