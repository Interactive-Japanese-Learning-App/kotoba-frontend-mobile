import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class WelcomeController extends GetxController {

  /// NAVIGASI KE LOGIN
  void goToLogin() {
    Get.toNamed(Routes.LOGIN);
  }
}