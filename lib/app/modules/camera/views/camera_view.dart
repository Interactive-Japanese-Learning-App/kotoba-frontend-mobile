import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/theme/app_colors.dart';
import '../../../widgets/app_header.dart';
import '../controllers/camera_controller.dart';

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
              /// 🔄 LOADING
              if (!controller.isCameraReady.value) {
                return SizedBox(
                  height: height,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              /// CAMERA UI
              return SizedBox(
                height: height,
                child: Stack(
                  children: [
                    _background(),
                    _overlay(height),
                    _cameraFrame(),
                    _popupLabel(),
                  ],
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
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Image.asset(
        "assets/images/bg-coffee.jpg",
        fit: BoxFit.cover,
      ),
    );
  }

  /// OVERLAY GELAP
  Widget _overlay(double height) {
    return Container(
      height: height,
      color: Colors.black.withOpacity(0.15),
    );
  }

  /// FRAME DETEKSI
  Widget _cameraFrame() {
    return Positioned.fill(
      child: Center(
        child: SizedBox(
          width: 260,
          height: 260,
          child: Stack(
            children: [
              _corner(top: true, left: true),
              _corner(top: true, left: false),
              _corner(top: false, left: true),
              _corner(top: false, left: false),
            ],
          ),
        ),
      ),
    );
  }

  /// POPUP LABEL (GETX REACTIVE)
  Widget _popupLabel() {
    return Positioned(
      top: 140,
      left: 0,
      right: 0,
      child: Center(
        child: Obx(() => Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      /// JAPANESE
                      Text(
                        controller.japanese.value,
                        style: const TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      /// ROMAJI + TRANSLATE
                      Text(
                        "${controller.romaji.value}\n${controller.translation.value}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                /// 🔻 GARIS KE OBJEK
                Container(
                  width: 2,
                  height: 20,
                  color: AppColors.warning,
                ),
              ],
            )),
      ),
    );
  }

  /// CORNER FRAME
  Widget _corner({required bool top, required bool left}) {
    return Positioned(
      top: top ? 0 : null,
      bottom: top ? null : 0,
      left: left ? 0 : null,
      right: left ? null : 0,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border(
            top: top
                ? BorderSide(color: AppColors.warning, width: 4)
                : BorderSide.none,
            bottom: !top
                ? BorderSide(color: AppColors.warning, width: 4)
                : BorderSide.none,
            left: left
                ? BorderSide(color: AppColors.warning, width: 4)
                : BorderSide.none,
            right: !left
                ? BorderSide(color: AppColors.warning, width: 4)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}