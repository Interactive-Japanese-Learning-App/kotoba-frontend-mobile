import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/theme/app_colors.dart';
import '../routes/app_pages.dart';

class KanaCard extends StatelessWidget {
  final String label;
  final String kana;
  final String type;

  const KanaCard({
    super.key,
    required this.label,
    required this.kana,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),

        /// 🔥 NAVIGASI KE CANVAS
        onTap: () {
          Get.toNamed(
            Routes.CANVAS,
            arguments: {
              'label': label,
              'kana': kana,
              'type': type,
            },
          );
        },

        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.neutral,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [

              /// 🔘 LABEL KECIL (a, i, u)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),

              /// 🔤 HURUF JEPANG
              Center(
                child: Text(
                  kana,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),

              /// 🏷️ TYPE (HIRAGANA / KATAKANA)
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  type,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}