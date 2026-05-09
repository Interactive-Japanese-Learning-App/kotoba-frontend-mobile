import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/theme/app_colors.dart';
import '../modules/main/controllers/bottom_nav_controller.dart';

class BottomNavbar extends GetView<BottomNavController> {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3E4A4E),
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _item(Icons.home, "Beranda", 0),
            _item(Icons.camera_alt_outlined, "Kamera", 1),
            _item(Icons.menu_book_outlined, "Belajar", 2),
            _item(Icons.person_outline, "Profil", 3),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icon, String label, int index) {
    final isActive = controller.currentIndex.value == index;

    return GestureDetector(
      onTap: () => controller.changeIndex(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: isActive ? AppColors.danger : Colors.grey.shade400,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive ? AppColors.danger : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}