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
    // Menggunakan LayoutBuilder agar responsif mendapatkan tinggi/lebar aktual container kamera
    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          const AppHeader(isScrolled: false),

          /// CAMERA CONTENT
          SliverToBoxAdapter(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Tentukan tinggi area kamera (misal: 80% dari tinggi layar)
                final double areaHeight =
                    MediaQuery.of(context).size.height * 0.8;
                final double areaWidth = MediaQuery.of(context).size.width;

                return Obx(() {
                  if (!controller.isCameraReady.value) {
                    return SizedBox(
                      height: areaHeight,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }

                  return SizedBox(
                    height: areaHeight,
                    width: areaWidth,
                    child: ClipRRect(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _background(),
                          _overlay(areaHeight),

                          // Mengirimkan dimensi pasti area kamera untuk kalkulasi bounding box
                          _buildDetectionOverlays(
                            context: context,
                            areaWidth: areaWidth,
                            areaHeight: areaHeight,
                          ),

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
                          SafeArea(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 50),
                                child: FloatingActionButton(
                                  backgroundColor: Colors.white,
                                  onPressed: controller.captureAndDetect,
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
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

  Widget _buildLabel(dynamic obj) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF355372).withOpacity(0.85),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            obj.jp,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14, // Ukuran disesuaikan agar lebih aman dari overflow
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            obj.rm,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
          Text(
            obj.tr,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// RENDER MULTIPEL BOUNDING BOX DAN LABEL DI ATASNYA
  Widget _buildDetectionOverlays({
    required BuildContext context,
    required double areaWidth,
    required double areaHeight,
  }) {
    return Obx(() {
      if (!controller.isDetecting.value || controller.detectedObjects.isEmpty) {
        return const SizedBox();
      }

      // 1. Ambil dimensi asli preview kamera
      final previewSize = controller.cameraController.value.previewSize;
      final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

      // Gunakan nilai default dari areaWidth/Height jika previewSize belum ada
      double pWidth = previewSize?.width ?? areaWidth;
      double pHeight = previewSize?.height ?? areaHeight;

      // 2. Koreksi orientasi jika perlu
      if (isPortrait && pWidth > pHeight) {
        final temp = pWidth;
        pWidth = pHeight;
        pHeight = temp;
      }

      // 3. Tentukan skala (Hapus deklarasi ulang pWidth/pHeight yang lama di sini!)
      final double scaleX = areaWidth / pWidth;
      final double scaleY = areaHeight / pHeight;

      return Stack(
        children: controller.detectedObjects.map((obj) {
          // 4. Hitung koordinat dengan skala yang sudah benar
          double calculatedLeft = obj.x * pWidth * scaleX;
          double calculatedTop = obj.y * pHeight * scaleY;
          double calculatedWidth = obj.w * pWidth * scaleX;
          double calculatedHeight = obj.h * pHeight * scaleY;

          // 5. Clamping agar box tidak keluar dari area kamera
          calculatedWidth = calculatedWidth.clamp(0.0, areaWidth);
          calculatedHeight = calculatedHeight.clamp(0.0, areaHeight);
          calculatedLeft = calculatedLeft.clamp(0.0, areaWidth - calculatedWidth);
          calculatedTop = calculatedTop.clamp(0.0, areaHeight - calculatedHeight);

          // (Logika Label tetap sama)
          const double labelWidth = 130;
          const double labelHeight = 65;
          double labelLeft = (calculatedLeft + (calculatedWidth / 2) - (labelWidth / 2)).clamp(0.0, areaWidth - labelWidth);
          
          double labelTop;
          if (calculatedWidth < 150 || calculatedHeight < 100) {
            labelTop = calculatedTop - labelHeight - 8;
            if (labelTop < 0) labelTop = calculatedTop + calculatedHeight + 8;
          } else {
            labelTop = calculatedTop + (calculatedHeight / 2) - (labelHeight / 2);
          }
          labelTop = labelTop.clamp(0.0, areaHeight - labelHeight);

          return Stack(
            children: [
              Positioned(
                left: calculatedLeft,
                top: calculatedTop,
                width: calculatedWidth,
                height: calculatedHeight,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              Positioned(
                left: labelLeft,
                top: labelTop,
                width: labelWidth,
                child: _buildLabel(obj),
              ),
            ],
          );
        }).toList(),
      );
    });
    }
}
