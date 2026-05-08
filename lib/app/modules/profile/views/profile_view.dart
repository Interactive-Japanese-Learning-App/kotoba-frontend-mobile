import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/theme/app_colors.dart';
import '../../../widgets/app_header.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      body: CustomScrollView(
        slivers: [
          const AppHeader(isScrolled: false),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  /// AVATAR
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: AppColors.neutral,
                    child: const Icon(Icons.person, size: 60),
                  ),

                  const SizedBox(height: 16),

                  /// USERNAME
                  Obx(() => Text(
                        controller.username.value.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )),

                  const SizedBox(height: 6),

                  /// EMAIL
                  Obx(() => Text(
                        controller.email.value,
                        style: TextStyle(color: Colors.grey[600]),
                      )),

                  const SizedBox(height: 30),

                  _menuItem("Edit Profil", controller.goEditProfile),
                  _divider(),
                  _menuItem("Tentang Aplikasi", controller.goAboutApp),
                  _divider(),
                  
                  const SizedBox(height: 40),

                  /// LOGOUT
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: controller.logout,
                      child: const Text(
                        "Keluar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _divider() {
    return Divider(color: Colors.grey[300]);
  }
}