import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/theme/app_colors.dart';
import '../../../widgets/app_header.dart';
import '../../../routes/app_pages.dart';

class LearnView extends StatelessWidget {
  const LearnView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      body: CustomScrollView(
        slivers: [
          const AppHeader(isScrolled: false),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  /// 🔷 TITLE
                  Text(
                    "Belajar",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Belajar dasar penulisan bahasa Jepang dengan pengucapan suara dan kuis.",
                    style: TextStyle(color: Colors.grey[600], height: 1.4),
                  ),

                  const SizedBox(height: 20),

                  /// 🔴 NIHONGO BASICS CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Stack(
                      children: [
                        /// 🔥 ICON BUKU BACKGROUND
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

                        /// 🔥 CONTENT
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
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Mulai Belajar →",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 🔷 2 CARD (WRITING & SPEECH)
                  Row(
                    children: [
                      /// 🔵 WRITING CANVAS
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(Routes.WRITING);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 150,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Writing Canvas",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Belajar cara menulis huruf Jepang",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                const Spacer(),
                                const Text(
                                  "Mulai Belajar →",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// 🟡 SPEECH RECOGNITION
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(Routes.SPEECH);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 150,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.warning,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Speech Recognition",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Belajar pengucapan bahasa Jepang",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                const Spacer(),
                                const Text(
                                  "Mulai Belajar →",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// ⚫ QUIZ CARD
                  InkWell(
                    onTap: () {
                      Get.toNamed(Routes.QUIZ);
                    },
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3E4A4E),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          /// 🔥 BACKGROUND ICON (pattern)
                          Positioned(
                            right: -10,
                            top: -10,
                            child: Transform.rotate(
                              angle: 0.3,
                              child: Icon(
                                Icons.extension_rounded,
                                size: 120,
                                color: Colors.white.withOpacity(0.05),
                              ),
                            ),
                          ),

                          /// 🔥 CONTENT
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Quiz",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              const Text(
                                "Uji pemahamanmu dengan kuis untuk memahami materi",
                                style: TextStyle(
                                  color: Colors.white70,
                                  height: 1.4,
                                ),
                              ),

                              const SizedBox(height: 20),

                              /// 🔥 BUTTON CAPSULE
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Mulai Kuis",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward, size: 16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
