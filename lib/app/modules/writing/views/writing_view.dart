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

        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),

          onPressed: () {
            Get.back();
          },
        ),

        title: Text(
          "Writing Canvas",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      body: SafeArea(
        top: false,
        bottom: true,
        child: Obx(() {
          final data = controller.currentData;

          return Column(
            children: [
              const SizedBox(height: 20),

              /// TAB
              SizedBox(
                height: 45,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _buildTab("Hiragana", 0),
                      const SizedBox(width: 12),

                      _buildTab("Katakana", 1),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// GRID
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
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
                        type: controller.currentType,
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  /// TAB UI
  Widget _buildTab(String title, int index) {
    return Obx(() {
      final isActive = controller.selectedIndex.value == index;

      return GestureDetector(
        onTap: () => controller.changeTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.danger : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.white : Colors.black54,
            ),
          ),
        ),
      );
    });
  }
}
