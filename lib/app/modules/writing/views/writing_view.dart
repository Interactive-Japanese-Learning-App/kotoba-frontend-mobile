import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/theme/app_colors.dart';
import '../../../widgets/kana_card.dart';
import '../controllers/writing_controller.dart';

class WritingView extends GetView<WritingController> {
  const WritingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leadingWidth: 50,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Writing Canvas",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        /// 🔥 OBX
        child: Obx(() {
          final data = controller.currentData;

          return Column(
            children: [

              /// 🔴 TAB
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTab("Hiragana", 0),
                  const SizedBox(width: 20),
                  _buildTab("Katakana", 1),
                ],
              ),

              const SizedBox(height: 20),

              /// 🔷 GRID
              Expanded(
                child: GridView.builder(
                  itemCount: data.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    final item = data[index];

                    return KanaCard(
                      label: item['label']!,
                      kana: item['kana']!,
                      type: controller.selectedIndex.value == 0
                          ? "HIRAGANA"
                          : "KATAKANA",
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  /// 🔴 TAB UI
  Widget _buildTab(String title, int index) {
    return Obx(() {
      final isActive = controller.selectedIndex.value == index;

      return GestureDetector(
        onTap: () => controller.changeTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.danger : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    });
  }
}