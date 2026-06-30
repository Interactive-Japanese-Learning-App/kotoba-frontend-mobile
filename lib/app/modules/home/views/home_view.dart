import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
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
                      "${controller.greeting.value}, ${controller.username.value}",
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

                    Obx(
                      () => Container(
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

                            Stack(
                              children: [
                                Container(
                                  height: 14,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.neutral,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),

                                FractionallySizedBox(
                                  widthFactor: controller.progress,
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

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${controller.currentLevelXp} XP",
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  "${controller.maxXp} XP",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                                "Nihongo Dasar",
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
                      "Top Channel Belajar Bahasa Jepang",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Rekomendasi channel YouTube terpopuler untuk belajar bahasa Jepang",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),

                    const SizedBox(height: 12),

                    Obx(
                      () => SizedBox(
                        height: 145,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          itemCount: controller.channels.length,
                          itemBuilder: (context, index) {
                            final channel = controller.channels[index];

                            return InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () async {
                                final url = Uri.parse(channel.channelUrl);

                                if (await canLaunchUrl(url)) {
                                  await launchUrl(
                                    url,
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              child: Container(
                                width: 270,
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.05),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.network(
                                        channel.thumbnail,
                                        width: 48,
                                        height: 48,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) {
                                          return Container(
                                            width: 48,
                                            height: 48,
                                            color: Colors.red.shade50,
                                            child: const Icon(
                                              Icons.smart_display_rounded,
                                              color: Colors.red,
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    const SizedBox(width: 14),

                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            channel.channelName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),

                                          const SizedBox(height: 4),

                                          Text(
                                            "${controller.formatNumber(channel.subscribers)} Subscriber",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey[600],
                                            ),
                                          ),

                                          const SizedBox(height: 8),

                                          Row(
                                            children: [
                                              Icon(
                                                Icons.visibility_rounded,
                                                size: 14,
                                                color: Colors.grey[700],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                controller.formatNumber(
                                                  channel.totalViews,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey[700],
                                                ),
                                              ),

                                              const SizedBox(width: 16),

                                              Icon(
                                                Icons.video_library_rounded,
                                                size: 14,
                                                color: Colors.grey[700],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                controller.formatNumber(
                                                  channel.totalVideos,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
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
