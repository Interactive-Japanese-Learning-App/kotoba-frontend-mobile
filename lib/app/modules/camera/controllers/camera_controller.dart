import 'package:get/get.dart';

class CameraController extends GetxController {
  final isCameraReady = false.obs;

  @override
  void onInit() {
    super.onInit();

    // nanti untuk init camera
    Future.delayed(const Duration(seconds: 1), () {
      isCameraReady.value = true;
    });
  }
}