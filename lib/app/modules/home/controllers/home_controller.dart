import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main/controllers/bottom_nav_controller.dart';

class HomeController extends GetxController {
  final scrollController = ScrollController();

  final RxBool isScrolled = false.obs;
  final RxString username = "Rani".obs;
  final RxInt streak = 12.obs;
  final RxInt progress = 75.obs;

  void changeTab(int index) {
    Get.find<BottomNavController>().changeTab(index);
  }

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    isScrolled.value = scrollController.offset > 10;
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }
}
