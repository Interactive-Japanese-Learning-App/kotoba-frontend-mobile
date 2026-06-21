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

      body: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: [
            const SizedBox(height: 10),

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
                    const SizedBox(width: 12),

                    _buildTab("Angka", 2),
                    const SizedBox(width: 12),

                    _buildTab("Bulan", 3),
                    const SizedBox(width: 12),

                    _buildTab("Tanggal", 4),
                    const SizedBox(width: 12),

                    _buildTab("Keluarga", 5),
                    const SizedBox(width: 12),

                    _buildTab("Hewan", 6),
                    const SizedBox(width: 12),

                    _buildTab("Makanan", 7),
                    const SizedBox(width: 12),

                    _buildTab("Minuman", 8),
                    const SizedBox(width: 12),

                    _buildTab("Pekerjaan", 9),
                    const SizedBox(width: 12),

                    _buildTab("Benda", 10),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// SEARCH
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
                  decoration: InputDecoration(
                    icon: const Icon(Icons.search, color: Colors.grey),
                    hintText: "Cari huruf...",
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: Obx(() {
                switch (controller.selectedIndex.value) {
                  case 0:
                    return _grid(controller.filteredHiragana, "HIRAGANA");

                  case 1:
                    return _grid(controller.filteredKatakana, "KATAKANA");

                  case 2:
                    return _grid(controller.filteredAngka, "ANGKA");

                  case 3:
                    return _grid(controller.filteredBulan, "BULAN");

                  case 4:
                    return _grid(controller.filteredTanggal, "TANGGAL");

                  case 5:
                    return _grid(controller.filteredKeluarga, "KELUARGA");

                  case 6:
                    return _grid(controller.filteredHewan, "HEWAN");

                  case 7:
                    return _grid(controller.filteredMakanan, "MAKANAN");

                  case 8:
                    return _grid(controller.filteredMinuman, "MINUMAN");

                  case 9:
                    return _grid(controller.filteredPekerjaan, "PEKERJAAN");

                  default:
                    return _grid(controller.filteredBenda, "BENDA");
                }
              }),
            ),
          ],
        ),
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

  // GRID
  Widget _grid(List<Map<String, dynamic>> data, String type) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (data.isEmpty) {
        return const Center(
          child: Text(
            "Data tidak ditemukan",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        );
      }

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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black12, width: 1),
                    ),
                    child: Text(
                      item["romaji"]?.toString() ?? "",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),

                /// CHARACTER
                Center(
                  child: SizedBox(
                    width: 100,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        item["character"]?.toString() ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                /// MEANING
                Positioned(
                  bottom: 18,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        item["meaning"]?.toString() ?? "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
