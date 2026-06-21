import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/theme/app_colors.dart';
import 'pelafalan_controller.dart';

class PelafalanView extends GetView<PelafalanController> {
  const PelafalanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.question.value == null) {
          return const Center(child: Text("Soal tidak ditemukan"));
        }

        final q = controller.question.value!;
        
        final targetWord = q["kana"] ?? q["question"] ?? "";
        final romaji = q["answer"] ?? q["label"] ?? q["romaji"] ?? "";

        return SafeArea(
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

                        /// TYPE / SECTION TITLE
                        Text(
                          controller.sectionTitle.isNotEmpty 
                              ? controller.sectionTitle.toUpperCase()
                              : (q["type"] ?? "PRONUNCIATION").toString().toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 2,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),

                        /// TITLE
                        Text(
                          "Ucapkan: $romaji",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 20),

                        /// CARD UTAMA
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
                                      targetWord, 
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 48, 
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      romaji, 
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    GestureDetector(
                                      onTap: () => controller.speak(targetWord),
                                      child: Container(
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
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        /// MIC BUTTON INTERAKTIF (Diisolasi dengan Obx lokal agar responsif merah seketika)
                        GestureDetector(
                          onTap: () => controller.toggleMic(targetWord, romaji),
                          child: Obx(() {
                            final listening = controller.isListening.value;
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: listening
                                        ? Colors.red.withOpacity(0.15)
                                        : AppColors.primary.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: listening
                                        ? Colors.red.withOpacity(0.2)
                                        : AppColors.primary.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Container(
                                  width: 65,
                                  height: 65,
                                  decoration: BoxDecoration(
                                    color: listening ? Colors.red : AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.mic,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                        const SizedBox(height: 15),
                        
                        /// STATUS TEXT MENDENGARKAN
                        Obx(() {
                          return Text(
                            controller.isListening.value
                                ? "MENDENGARKAN..."
                                : "TAP UNTUK BERBICARA",
                            style: const TextStyle(
                              letterSpacing: 2,
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          );
                        }),
                        const SizedBox(height: 15),
                        
                        /// RECOGNIZED LIVE TEXT ROMAJI RESULT (Hasil dijamin selalu teks latin bebas aksara jepang)
                        Obx(() {
                          if (controller.recognizedText.value.trim().isEmpty) {
                            return const SizedBox(height: 22);
                          }

                          String liveRomaji = controller.convertedRomajiResult.value.trim();

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              liveRomaji, 
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: liveRomaji.startsWith("(") ? Colors.red.shade400 : Colors.black87,
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}