import 'package:get/get.dart';
import 'package:kotoba_app/app/modules/camera/controllers/camera_controller.dart';
import 'package:kotoba_app/app/modules/home/controllers/home_controller.dart';
import 'package:kotoba_app/app/modules/learn/controllers/learn_controller.dart';
import 'package:kotoba_app/app/modules/profile/controllers/profile_controller.dart';
import '../controllers/bottom_nav_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BottomNavController());

    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => CameraController());
    Get.lazyPut(() => LearnController());
    Get.lazyPut(() => ProfileController());
  }
}
