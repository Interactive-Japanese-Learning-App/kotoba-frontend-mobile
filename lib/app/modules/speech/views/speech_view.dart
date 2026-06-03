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

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Obx(() {
          final data = controller.currentData;

          return Column(
            children: [
              /// TAB
              SizedBox(
                height: 45,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildTab("Angka", 0),
                    _buildTab("Bulan", 1),
                    _buildTab("Tanggal", 2),
                    _buildTab("Keluarga", 3),
                    _buildTab("Hewan", 4),
                    _buildTab("Makanan", 5),
                    _buildTab("Minuman", 6),
                    _buildTab("Pekerjaan", 7),
                    _buildTab("Benda", 8),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// GRID
              Expanded(
                child: GridView.builder(
                  itemCount: data.length,

                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),

                  itemBuilder: (context, index) {
                    final Map<String, String> item = data[index];

                    return InkWell(
                      onTap: () {
                        controller.clearResult();
                        Get.toNamed(
                          Routes.SPEECH_DETAIL,
                          arguments: {
                            ...item, // <-- jangan dihapus
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

                      borderRadius: BorderRadius.circular(20),

                      child: Container(
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: AppColors.neutral,
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Stack(
                          children: [
                            /// LABEL
                            Positioned(
                              top: 0,
                              left: 0,
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

                            /// ISI
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
                                            fontSize: 36,
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
                            /// TYPE
                            Align(
                              alignment: Alignment.bottomCenter,
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
          width: 100,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.danger : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
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
