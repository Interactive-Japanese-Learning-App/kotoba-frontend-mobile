import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/theme/app_colors.dart';
import '../../../widgets/app_header.dart';
import '../controllers/learn_controller.dart';

class LearnView extends GetView<LearnController> {
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
                  const SizedBox(height: 8),

                  /// TITLE
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

                  /// NIHONGO BASICS
                  _nihongoCard(),

                  const SizedBox(height: 16),

                  /// WRITING + SPEECH
                  Row(
                    children: [
                      Expanded(child: _writingCard()),
                      const SizedBox(width: 12),
                      Expanded(child: _speechCard()),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// QUIZ
                  _quizCard(),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// NIHONGO CARD
  Widget _nihongoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.danger,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        children: [
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
                onTap: controller.goToNihongo,
                borderRadius: BorderRadius.circular(30),
                child: _buttonWhite("Mulai Belajar"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// WRITING
  Widget _writingCard() {
    return InkWell(
      onTap: controller.goToWriting,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage("assets/images/bg-canvas.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.primary.withOpacity(0.6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Menulis Kanvas",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Belajar cara menulis huruf Jepang",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),

              const Spacer(),

              _arrowText(),
            ],
          ),
        ),
      ),
    );
  }

  /// SPEECH
  Widget _speechCard() {
    return InkWell(
      onTap: controller.goToSpeech,
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
              "Pelafalan Suara",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Belajar pengucapan bahasa Jepang",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),

            const Spacer(),

            _arrowText(),
          ],
        ),
      ),
    );
  }

  /// QUIZ
  Widget _quizCard() {
    return InkWell(
      onTap: controller.goToQuiz,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF3E4A4E),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
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
              "Uji pemahamanmu dengan kuis",
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 20),

            _buttonWhite("Mulai Kuis"),
          ],
        ),
      ),
    );
  }

  /// BUTTON PUTIH
  Widget _buttonWhite(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward, size: 16),
        ],
      ),
    );
  }

  /// TEXT ARROW
  Widget _arrowText() {
    return const Row(
      children: [
        Text("Mulai Belajar", style: TextStyle(color: Colors.white)),
        SizedBox(width: 8),
        Icon(Icons.arrow_forward, size: 16, color: Colors.white),
      ],
    );
  }
}