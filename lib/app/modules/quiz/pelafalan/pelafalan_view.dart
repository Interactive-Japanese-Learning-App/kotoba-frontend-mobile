import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/theme/app_colors.dart';
import 'pelafalan_controller.dart';

class PelafalanView extends GetView<PelafalanController> {
  const PelafalanView({super.key});

  @override
  Widget build(BuildContext context) {
    final q = controller.question;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leadingWidth: 50,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Pelafalan",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      /// SUBTITLE (STATIC SAMA)
                      Text(
                        q["type"]!,
                        style: const TextStyle(
                          fontSize: 11,
                          letterSpacing: 2,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// TITLE (SAMA STYLE)
                      Text(
                        "Ucapkan: ${q["label"]}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// CARD (100% SAMA SPEECH)
                      Container(
                        width: 280,
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            /// GARIS KIRI (SAMA)
                            Positioned(
                              left: 0,
                              top: 10,
                              bottom: 10,
                              child: Container(
                                width: 5,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),

                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    q["kana"]!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 120,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    q["label"]!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF4E7C2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.volume_up,
                                          size: 16,
                                          color: AppColors.primary,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          "DENGARKAN SENSEI",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// MIC (SAMA 100%)
                      Obx(
                        () => GestureDetector(
                          onTap: controller.toggleMic,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: controller.isListening.value
                                      ? Colors.red.withOpacity(0.15)
                                      : AppColors.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                              ),

                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: controller.isListening.value
                                      ? Colors.red.withOpacity(0.2)
                                      : AppColors.primary.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                              ),

                              Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  color: controller.isListening.value
                                      ? Colors.red
                                      : AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.mic,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Obx(
                        () => Text(
                          controller.isListening.value
                              ? "MENDENGARKAN..."
                              : "TAP UNTUK BERBICARA",
                          style: const TextStyle(
                            letterSpacing: 2,
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
