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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(25),
        child: InkWell(
          borderRadius: BorderRadius.circular(25),

          onTap: () {
            Get.toNamed(
              Routes.CANVAS,
              arguments: {'label': label, 'kana': kana, 'type': type},
            );
          },

          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                /// LABEL
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Text(label, style: const TextStyle(fontSize: 12)),
                  ),
                ),

                /// HURUF JEPANG
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

                /// TYPE
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    type,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
