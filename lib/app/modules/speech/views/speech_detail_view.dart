import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/theme/app_colors.dart';
import '../controllers/speech_controller.dart';

class SpeechDetailView extends GetView<SpeechController> {
  const SpeechDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;

    final kana = args["kana"] ?? "";
    final label = args["label"] ?? "";
    final type = args["type"] ?? "";

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      /// TYPE
                      Text(
                        type,
                        style: const TextStyle(
                          fontSize: 11,
                          letterSpacing: 2,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// TITLE
                      Text(
                        "Ucapkan: $label",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// CARD
                      _buildCard(
                        kana: kana,
                        label: label,
                      ),

                      const SizedBox(height: 30),

                      /// MIC
                      Obx(() => _buildMic()),

                      const SizedBox(height: 15),

                      /// STATUS
                      Obx(
                        () => Text(
                          controller.isListening.value
                              ? "MENDENGARKAN..."
                              : "TAP UNTUK BERBICARA",
                          style: const TextStyle(
                            letterSpacing: 2,
                            color: Colors.grey,
                            fontSize: 11,
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

  // =====================================================
  // CARD
  // =====================================================

  Widget _buildCard({
    required String kana,
    required String label,
  }) {
    return Container(
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
                /// KANA
                Text(
                  kana,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 120,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 8),

                /// ROMAJI
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 20),

                /// BUTTON
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
    );
  }

  // =====================================================
  // MIC
  // =====================================================

  Widget _buildMic() {
    return GestureDetector(
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
    );
  }
}