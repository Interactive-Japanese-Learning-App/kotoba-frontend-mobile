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

                  /// 🔷 AVATAR
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: AppColors.neutral,
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 🔷 USERNAME
                  Obx(() => Text(
                        controller.username.value.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      )),

                  const SizedBox(height: 6),

                  /// 🔷 EMAIL
                  Obx(() => Text(
                        controller.email.value,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      )),

                  const SizedBox(height: 30),

                  /// 🔷 MENU LIST
                  _menuItem("Edit Profil", controller.goEditProfile),
                  _divider(),
                  _menuItem("Tentang Aplikasi", () {}),
                  _divider(),
                  _menuItem("Kritik & Saran", () {}),

                  const SizedBox(height: 40),

                  /// 🔴 BUTTON KELUAR
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

  /// 🔷 MENU ITEM
  Widget _menuItem(String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  /// 🔷 DIVIDER
  Widget _divider() {
    return Divider(
      color: Colors.grey[300],
      thickness: 1,
      height: 1,
    );
  }
}