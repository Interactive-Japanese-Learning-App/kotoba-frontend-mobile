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
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    const headerHeight = 100.0;
    const navbarHeight = 80.0;

    final height =
        screenHeight -
        headerHeight -
        navbarHeight -
        topPadding -
        bottomPadding;

    print("screenHeight = $screenHeight");
    print("cameraHeight = $height");

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

  Widget _buildLabel(dynamic obj) {
    return Container(
      constraints: const BoxConstraints(minWidth: 100, maxWidth: 150),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF355372).withOpacity(0.85),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              obj.jp,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
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
      ),
    );
  }

  /// RENDER MULTIPEL BOUNDING BOX DAN LABEL DI ATASNYA
  Widget _buildDetectionOverlays(double areaHeight) {
    return Obx(() {
      if (!controller.isDetecting.value || controller.detectedObjects.isEmpty) {
        return const SizedBox();
      }

      final double screenWidth = Get.width;
      final double screenHeight = areaHeight;
      final uniqueObjects = <String, dynamic>{};

      for (var obj in controller.detectedObjects) {
        uniqueObjects[obj.jp] = obj;
      }

      final objects = uniqueObjects.values.where((obj) {
        final left = obj.x * screenWidth;
        final top = obj.y * screenHeight;
        final width = obj.w * screenWidth;
        final height = obj.h * screenHeight;

        final right = left + width;
        final bottom = top + height;

        return left >= 0 &&
            top >= 0 &&
            right <= screenWidth &&
            bottom <= screenHeight &&
            width >= 20 &&
            height >= 20;
      }).toList();

      return Stack(
        children: objects.map((obj) {
          final double calculatedLeft = obj.x * screenWidth;
          final double calculatedTop = obj.y * screenHeight;
          final double calculatedWidth = obj.w * screenWidth;
          final double calculatedHeight = obj.h * screenHeight;

          // UI helper: untuk bounding box kecil, label diposisikan ke atas box.
          final bool smallBox = calculatedWidth < 180 || calculatedHeight < 100;

          final double safeWidth = calculatedWidth;
          final maxLeft = (screenWidth - calculatedWidth).clamp(
            0.0,
            double.infinity,
          );

          final double safeLeft = calculatedLeft.clamp(0.0, maxLeft);
          final double labelWidth = 150;

          final maxLabelLeft = (screenWidth - safeLeft - labelWidth).clamp(
            0.0,
            double.infinity,
          );

          final double labelLeft = ((safeWidth / 2) - (labelWidth / 2)).clamp(
            0.0,
            maxLabelLeft,
          );
          if (calculatedWidth <= 0 ||
              calculatedHeight <= 0 ||
              calculatedWidth.isNaN ||
              calculatedHeight.isNaN) {
            return const SizedBox();
          }

          if (calculatedWidth > screenWidth * 0.8 ||
              calculatedHeight > screenHeight * 0.8) {
            return const SizedBox();
          }

          return Positioned(
            left: safeLeft,
            top: smallBox
                ? (calculatedTop < 85 ? 85 : calculatedTop)
                : calculatedTop,
            width: safeWidth,
            height: calculatedHeight,
            child: Stack(
              clipBehavior: Clip.none,
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

                // 2. LABEL INFORMASI
                // - Jika box kecil => label dipindah ke atas (agar tidak bottom-overflow)
                // - Jika box besar => label tetap di tengah
                if (smallBox)
                  Positioned(
                    top: -75,
                    left: labelLeft,
                    child: SizedBox(width: labelWidth, child: _buildLabel(obj)),
                  )
                else
                  Center(child: _buildLabel(obj)),
              ],
            ),
          );
        }).toList(),
      );
    });
  }
}
