import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/theme/app_colors.dart';
import '../controllers/speech_controller.dart';
import '../../../routes/app_pages.dart';

class SpeechView extends GetView<SpeechController> {
  const SpeechView({super.key});

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
          "Speech Recognition",
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
        child: Obx(() {
          final data = controller.currentData;

          return Column(
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
                      _buildTab("Angka", 0),
                      const SizedBox(width: 12),

                      _buildTab("Bulan", 1),
                      const SizedBox(width: 12),

                      _buildTab("Tanggal", 2),
                      const SizedBox(width: 12),

                      _buildTab("Keluarga", 3),
                      const SizedBox(width: 12),

                      _buildTab("Hewan", 4),
                      const SizedBox(width: 12),

                      _buildTab("Makanan", 5),
                      const SizedBox(width: 12),

                      _buildTab("Minuman", 6),
                      const SizedBox(width: 12),

                      _buildTab("Pekerjaan", 7),
                      const SizedBox(width: 12),

                      _buildTab("Benda", 8),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// GRID
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: data.length,

                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1,
                  ),

                  itemBuilder: (context, index) {
                    final Map<String, String> item = data[index];

                    return InkWell(
                      borderRadius: BorderRadius.circular(25),

                      onTap: () {
                        controller.clearResult();

                        Get.toNamed(
                          Routes.SPEECH_DETAIL,
                          arguments: {
                            ...item,
                            "type": [
                              "ANGKA",
                              "BULAN",
                              "TANGGAL",
                              "KELUARGA",
                              "HEWAN",
                              "MAKANAN",
                              "MINUMAN",
                              "PEKERJAAN",
                              "BENDA",
                            ][controller.selectedIndex.value],
                          },
                        );
                      },

                      child: Container(
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
                            /// LABEL
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                constraints: const BoxConstraints(
                                  minWidth: 35,
                                  maxWidth: 65,
                                  minHeight: 22,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 4,
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.black12),
                                ),
                                child: Text(
                                  item['label']!,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ),

                            /// KANA
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 55,
                                    child: Center(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          item['kana']!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    item['indo'] ?? "",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// TYPE
                            Positioned(
                              bottom: 18,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Text(
                                  [
                                    "ANGKA",
                                    "BULAN",
                                    "TANGGAL",
                                    "KELUARGA",
                                    "HEWAN",
                                    "MAKANAN",
                                    "MINUMAN",
                                    "PEKERJAAN",
                                    "BENDA",
                                  ][controller.selectedIndex.value],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  /// TAB
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
