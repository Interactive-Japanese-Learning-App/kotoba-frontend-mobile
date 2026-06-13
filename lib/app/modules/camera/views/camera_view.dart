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
                final double areaHeight = MediaQuery.of(context).size.height * 0.8;
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
  Widget _buildDetectionOverlays({required double areaWidth, required double areaHeight}) {
    return Obx(() {
      if (!controller.isDetecting.value || controller.detectedObjects.isEmpty) {
        return const SizedBox();
      }

      // Ambil preview size dari kamera untuk menghitung kecocokan rasio aspek (scaling factor)
      // Ini kunci utama agar kotak presisi di semua ukuran HP
      final previewSize = controller.cameraController.value.previewSize;
      
      // Default fallback jika previewSize belum termuat
      double scaleY = areaHeight;

      if (previewSize != null) {
        // Kamera biasanya mendeteksi dalam kondisi Landscape secara sistem, 
        // sehingga kita perlu mencocokkan koordinatnya ke Portrait layar HP.
        final double previewHeight = previewSize.width; 
        final double previewWidth = previewSize.height;

        scaleY = areaHeight / previewHeight;
      }

      final uniqueObjects = <String, dynamic>{};
      for (var obj in controller.detectedObjects) {
        uniqueObjects[obj.jp] = obj;
      }

      final objects = uniqueObjects.values.where((obj) {
        // Kalkulasi dimensi mentah dengan skala rasio aspek
        final w = obj.w * areaWidth;
        final h = obj.h * areaHeight;
        return w >= 20 && h >= 20;
      }).toList();

      return Stack(
        children: objects.map((obj) {
          // 1. Hitung koordinat Box Dasar
          double calculatedLeft = obj.x * areaWidth;
          double calculatedTop = obj.y * areaHeight;
          double calculatedWidth = obj.w * areaWidth;
          double calculatedHeight = obj.h * areaHeight;

          // 2. Kunci agar BOX tidak melebihi batas tepi kamera (clamping)
          calculatedWidth = calculatedWidth.clamp(0.0, areaWidth);
          calculatedHeight = calculatedHeight.clamp(0.0, areaHeight);
          calculatedLeft = calculatedLeft.clamp(0.0, areaWidth - calculatedWidth);
          calculatedTop = calculatedTop.clamp(0.0, areaHeight - calculatedHeight);

          if (calculatedWidth <= 0 || calculatedHeight <= 0 || calculatedWidth.isNaN || calculatedHeight.isNaN) {
            return const SizedBox();
          }

          // 3. Logika Penempatan Label yang Aman (Tidak boleh negatif/keluar kamera)
          const double labelWidth = 130; // Batasi lebar fix label
          const double labelHeight = 65; // Perkiraan tinggi label maksimum

          // Posisi horizontal label (tengah-tengah box)
          double labelLeft = calculatedLeft + (calculatedWidth / 2) - (labelWidth / 2);
          labelLeft = labelLeft.clamp(0.0, areaWidth - labelWidth); // Jaga agar tidak keluar kanan/kiri kamera

          // Posisi vertikal label
          double labelTop;
          final bool isSmallBox = calculatedWidth < 150 || calculatedHeight < 100;

          if (isSmallBox) {
            // Jika box kecil, coba letakkan di ATAS kotak
            labelTop = calculatedTop - labelHeight - 8;
            // JIKA di atas kotak ternyata mentok batas atas kamera (< 0), pindahkan ke BAWAH kotak
            if (labelTop < 0) {
              labelTop = calculatedTop + calculatedHeight + 8;
            }
          } else {
            // Jika box besar, letakkan tepat di TENGAH kotak
            labelTop = calculatedTop + (calculatedHeight / 2) - (labelHeight / 2);
          }

          // Jaga final posisi vertikal label agar mutlak tetap berada di dalam area kamera
          labelTop = labelTop.clamp(0.0, areaHeight - labelHeight);

          return Stack(
            children: [
              // Bounding Box Merah
              Positioned(
                left: calculatedLeft,
                top: calculatedTop,
                width: calculatedWidth,
                height: calculatedHeight,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2.5),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.15),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),

              // Label Informasi Terpisah (Ditempatkan secara absolut pada level stack kamera utama)
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