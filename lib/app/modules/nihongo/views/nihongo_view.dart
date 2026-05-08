import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/theme/app_colors.dart';
import '../controllers/nihongo_controller.dart';

class NihongoView extends GetView<NihongoController> {
  const NihongoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      /// APPBAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leadingWidth: 50,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Nihongo Basics",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          /// TAB 
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTab("Hiragana", 0),
              const SizedBox(width: 20),
              _buildTab("Katakana", 1),
              const SizedBox(width: 20),
              _buildTab("Angka", 2),
            ],
          ),

          const SizedBox(height: 15),

          ///  SEARCH
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: AppColors.neutral,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                onChanged: controller.updateSearch,
                decoration: const InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: "Cari huruf...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// CONTENT
          Expanded(
            child: Obx(() {
              if (controller.selectedIndex.value == 0) {
                return _grid(controller.filteredHiragana, "HIRAGANA");
              } else if (controller.selectedIndex.value == 1) {
                return _grid(controller.filteredKatakana, "KATAKANA");
              } else {
                return _grid(controller.filteredAngka, "ANGKA");
              }
            }),
          ),
        ],
      ),
    );
  }

  // TAB ITEM 
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
            ),
          ),
        ),
      );
    });
  }

  // GRID
  Widget _grid(List<Map<String, String>> data, String type) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: data.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final item = data[index];

        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              /// ROMAJI
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    item["romaji"] ?? "",
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),

              /// HURUF
              Center(
                child: Text(
                  item["char"] ?? "",
                  style: TextStyle(
                    fontSize: 60,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              /// TYPE
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    type,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}