import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottom_nav_controller.dart';
import '../../home/views/home_view.dart';
import '../../camera/views/camera_view.dart';
import '../../learn/views/learn_view.dart';
import '../../profile/views/profile_view.dart';
import '../../../widgets/bottom_navbar.dart';

class MainView extends GetView<BottomNavController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: [
            HomeView(), // 0
            const CameraView(), // 1
            const LearnView(), // 2
            const ProfileView(), // 3
          ],
        ),
        bottomNavigationBar: const BottomNavbar(),
      ),
    );
  }
}
