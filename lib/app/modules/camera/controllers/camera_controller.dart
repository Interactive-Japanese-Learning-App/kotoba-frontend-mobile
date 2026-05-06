import 'package:get/get.dart';

class CameraController extends GetxController {
  final isCameraReady = false.obs;

  /// DATA DETEKSI (Reactive)
  final japanese = "コーヒー".obs;
  final romaji = "KŌHĪ".obs;
  final translation = "KOPI".obs;

  @override
  void onInit() {
    super.onInit();

    // simulasi init camera
    Future.delayed(const Duration(seconds: 1), () {
      isCameraReady.value = true;
    });
  }

  /// nanti dipakai untuk update dari AI
  void updateDetection({
    required String jp,
    required String rm,
    required String tr,
  }) {
    japanese.value = jp;
    romaji.value = rm;
    translation.value = tr;
  }
}