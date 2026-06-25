import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../main/controllers/bottom_nav_controller.dart';
import '../../../data/services/api_service.dart';
import '../../../data/models/user_profile_model.dart';

class HomeController extends GetxController {
  final scrollController = ScrollController();

  final isScrolled = false.obs;

  final username = ''.obs;

  /// Greeting
  final greeting = "Konnichiwa".obs;

  /// User Profile
  final xp = 0.obs;
  final level = 1.obs;

  /// XP maksimum
  final int maxXp = 100;

  /// Storage
  final box = GetStorage();

  /// Video list
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

  /// Progress bar
  double get progress {
    return xp.value.clamp(0, maxXp) / maxXp;
  }

  /// XP saat ini
  int get currentLevelXp {
    return xp.value.clamp(0, maxXp);
  }

  void changeTab(int index) {
    Get.find<BottomNavController>().changeIndex(index);
  }

  @override
  void onInit() {
    super.onInit();

    _setGreeting();

    username.value = box.read('username') ?? '';

    scrollController.addListener(_onScroll);

    loadProfile();
  }

  @override
  void onReady() {
    super.onReady();

    // setiap halaman home muncul, refresh profile
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final userId = box.read('userId');

      if (userId == null) return;

      final result = await ApiService.getProfile(userId);

      print("PROFILE RESPONSE = $result");

      final user = UserProfile.fromJson(result["user"]);

      xp.value = user.xp;
      level.value = user.level;

      print("XP HOME = ${xp.value}");
      print("LEVEL HOME = ${level.value}");
    } catch (e) {
      debugPrint("LOAD PROFILE ERROR : $e");
    }
  }

  void _setGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 11) {
      greeting.value = "Ohayou";
    } else if (hour >= 11 && hour < 18) {
      greeting.value = "Konnichiwa";
    } else {
      greeting.value = "Konbanwa";
    }
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
