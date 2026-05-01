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

          SliverToBoxAdapter(
            child: Stack(
              children: [

                /// 📸 BACKGROUND
                SizedBox(
                  height: height,
                  width: double.infinity,
                  child: Image.asset(
                    "assets/images/bg-coffee.jpg",
                    fit: BoxFit.cover,
                  ),
                ),

                /// 🔲 OVERLAY GELAP TIPIS
                Container(
                  height: height,
                  color: Colors.black.withOpacity(0.15),
                ),

                /// 🟨 FRAME CORNER (BUKAN BOX FULL)
                Positioned.fill(
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
                ),

                /// 🟦 POPUP LABEL
                Positioned(
                  top: 140,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [

                      /// BOX
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
                          children: const [
                            Text(
                              "コーヒー",
                              style: TextStyle(
                                fontSize: 26,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "KŌHĪ\nKOPI",
                              style: TextStyle(
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔧 WIDGET SUDUT FRAME
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