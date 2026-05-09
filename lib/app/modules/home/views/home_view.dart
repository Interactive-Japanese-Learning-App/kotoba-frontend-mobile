import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotoba_app/app/routes/app_pages.dart';
import '../../../data/theme/app_colors.dart';
import '../../../widgets/app_header.dart';
import '../controllers/home_controller.dart';
import '../../main/controllers/bottom_nav_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      body: Obx(
        () => CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            AppHeader(isScrolled: controller.isScrolled.value),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// GREETING
                    Text(
                      "Konnichiwa, ${controller.username.value}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Siap belajar?",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// XP PROGRESS CARD (NEW UI)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// TITLE
                          Text(
                            "Progres XP",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Lanjutkan progresmu!",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 14),

                          /// PROGRESS BAR
                          Stack(
                            children: [
                              /// BACKGROUND BAR
                              Container(
                                height: 14,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.neutral,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),

                              /// PROGRESS FILL
                              FractionallySizedBox(
                                widthFactor: controller.progress.value / 100,
                                child: Container(
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: AppColors.warning,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          /// XP TEXT
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${controller.progress.value} XP",
                                style: const TextStyle(fontSize: 12),
                              ),
                              const Text(
                                "100 XP",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// NIHONGO CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.danger,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Stack(
                        children: [
                          /// ICON MIRING
                          Positioned(
                            right: 10,
                            bottom: 0,
                            child: Transform.rotate(
                              angle: -0.35,
                              child: Icon(
                                Icons.menu_book_rounded,
                                size: 130,
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Nihongo Basics",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),

                              const Text(
                                "Pembelajaran Dasar",
                                style: TextStyle(color: Colors.white),
                              ),

                              const SizedBox(height: 20),

                              InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.NIHONGO);
                                },
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Mulai Belajar",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward, size: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// VISUAL SENSEI
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/bg-city.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),

                          /// OVERLAY BIRU
                          color: AppColors.primary.withOpacity(0.6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    const Text(
                                      "Visual Sensei",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8), // FIX SPACING

                                const Text(
                                  "Arahkan kamera pada objek \ndisekitarmu",
                                  style: TextStyle(
                                    color: Colors.white,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),

                            /// BUTTON VISUAL SENSEI (FIX)
                            InkWell(
                              onTap: () {
                                Get.find<BottomNavController>().changeIndex(1); 
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.danger,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "Mulai",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// SECTION VIDEO
                    Text(
                      "Belajar Bahasa Jepang",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Tonton video belajar Bahasa Jepang terpopuler untuk belajar lebih mudah dan cepat.",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),

                    const SizedBox(height: 14),

                    /// LIST VIDEO
                    Obx(
                      () => Column(
                        children: List.generate(controller.videos.length, (
                          index,
                        ) {
                          final video = controller.videos[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                /// THUMBNAIL
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    video["thumbnail"]!,
                                    width: 110,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                /// TEXT
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        video["title"]!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        video["channel"]!,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
