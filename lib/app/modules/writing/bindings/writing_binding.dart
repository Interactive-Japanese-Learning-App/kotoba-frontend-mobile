import 'package:get/get.dart';

import '../controllers/writing_controller.dart';

class WritingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WritingController>(
      () => WritingController(),
    );
  }
}
