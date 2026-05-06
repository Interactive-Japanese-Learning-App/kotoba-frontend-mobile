import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main/controllers/bottom_nav_controller.dart';

class HomeController extends GetxController {
  final scrollController = ScrollController();

  final RxBool isScrolled = false.obs;
  final RxString username = "ranifa".obs;
  final RxInt streak = 12.obs;
  final RxInt progress = 75.obs;

  /// FIX: pakai changeIndex
  void changeTab(int index) {
    Get.find<BottomNavController>().changeIndex(index);
  }

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      final email = (args['email'] ?? '') as String;
      final uname = (args['username'] ?? '') as String;
      if (uname.isNotEmpty) username.value = uname;

      // fallback kalau username tidak dikirim
      if (username.value.isEmpty && email.contains('@')) {
        username.value = email.split('@').first;
      }
    }

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

  var videos = [
    {
      "title": "Belajar Hiragana Dasar",
      "channel": "Kotoba Sensei",
      "thumbnail": "assets/images/bg-city.jpg",
    },
    {
      "title": "Katakana Mudah",
      "channel": "Nihongo Channel",
      "thumbnail": "assets/images/bg-city.jpg",
    },
    {
      "title": "Percakapan Jepang",
      "channel": "Anime Talk",
      "thumbnail": "assets/images/bg-city.jpg",
    },
  ].obs;
}