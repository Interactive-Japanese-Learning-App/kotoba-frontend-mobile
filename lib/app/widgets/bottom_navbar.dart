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
        padding: EdgeInsets.only(
          top: 10,
          bottom: MediaQuery.of(context).padding.bottom + 10,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
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
            size: 22,
            color: isActive ? AppColors.danger : Colors.grey.shade400,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive ? AppColors.danger : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
