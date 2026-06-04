import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/theme/app_colors.dart';
import '../../../widgets/app_header.dart';
import '../controllers/camera_controller.dart';
import 'package:camera/camera.dart' as cam;

class CameraView extends GetView<CameraController> {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.8;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          const AppHeader(isScrolled: false),

          /// CAMERA CONTENT
          SliverToBoxAdapter(
            child: Obx(() {
              if (!controller.isCameraReady.value) {
                return SizedBox(
                  height: height,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              return SizedBox(
                height: height,
                child: ClipRRect(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _background(),
                      _overlay(height),

                      // Mengganti frame tunggal menjadi penampung multipel boks & label
                      _buildDetectionOverlays(height),

                      /// INDIKATOR PROSES LOADING FOTO
                      Obx(
                        () => controller.isProcessing.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const SizedBox(),
                      ),

                      /// TOMBOL SHUTTER UNTUK DETEKSI
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: FloatingActionButton(
                            backgroundColor: Colors.white,
                            onPressed: () => controller.captureAndDetect(),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// BACKGROUND
  Widget _background() {
    return cam.CameraPreview(controller.cameraController);
  }

  /// OVERLAY GELAP
  Widget _overlay(double height) {
    return Container(height: height, color: Colors.black.withOpacity(0.15));
  }

  /// RENDER MULTIPEL BOUNDING BOX DAN LABEL DI ATASNYA
  Widget _buildDetectionOverlays(double areaHeight) {
    return Obx(() {
      if (!controller.isDetecting.value || controller.detectedObjects.isEmpty) {
        return const SizedBox();
      }

      final double screenWidth = Get.width;
      final double screenHeight = areaHeight;

      // Map seluruh object yang ada di list untuk dijadikan widget Positioned
      return Stack(
        children: controller.detectedObjects.map((obj) {
          final double calculatedLeft = obj.x * screenWidth;
          final double calculatedTop = obj.y * screenHeight;
          final double calculatedWidth = obj.w * screenWidth;
          final double calculatedHeight = obj.h * screenHeight;

          return Positioned(
            left: calculatedLeft,
            top: calculatedTop,
            width: calculatedWidth,
            height: calculatedHeight,
            child: Stack(
              clipBehavior: Clip
                  .none, // Membantu agar label menyembul keluar boks tanpa terpotong
              children: [
                // 1. GARIS KOTAK MERAH (BOUNDING BOX)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2.5),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.2),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),

                // 2. LABEL INFORMASI (3 Baris: JP, Romaji, Indonesia)
                Positioned(
                  top:
                      -80, // Ditinggikan agar teks 3 baris tidak menutupi kotak merah
                  left: -20,
                  right: -20,
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 90),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 1. Baris Atas: Aksara Jepang
                          Text(
                            obj.jp,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // 2. Baris Tengah: Romaji
                          Text(
                            obj.rm,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              color: Colors.white70,
                            ),
                          ),
                          // 3. Baris Bawah: Indonesia
                          Text(
                            obj.tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }
}
