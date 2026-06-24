import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/theme/app_colors.dart';
import '../controllers/activity_log_controller.dart';

class ActivityLogView extends GetView<ActivityLogController> {
  const ActivityLogView({super.key});

  IconData getIcon(String type) {
    switch (type) {
      case "learning":
        return Icons.menu_book_rounded;

      case "kana_writing":
        return Icons.edit_note_rounded;

      case "pronunciation":
        return Icons.mic_rounded;

      case "quiz":
        return Icons.quiz_rounded;

      case "login":
        return Icons.login_rounded;

      case "logout":
        return Icons.logout_rounded;

      case "register":
        return Icons.person_add_alt_1_rounded;

      case "edit_profile":
        return Icons.manage_accounts_rounded;

      case "reset_password":
        return Icons.lock_reset_rounded;

      case "delete_account":
        return Icons.delete_forever_rounded;

      case "object_detection":
        return Icons.camera_alt_rounded;

      case "profile":
        return Icons.person_rounded;

      default:
        return Icons.history_rounded;
    }
  }

  Color getColor(String type) {
    switch (type) {
      case "learning":
        return const Color(0xFF6C63FF); // ungu
      case "kana_writing":
        return const Color(0xFFFF8A00); // oranye
      case "pronunciation":
        return const Color(0xFF00B894); // hijau mint
      case "quiz":
        return const Color(0xFF0984E3); // biru
      case "login":
        return const Color(0xFF00CEC9); // turquoise
      case "logout":
        return const Color(0xFFE17055); // merah bata
      case "register":
        return const Color(0xFFE84393); // pink
      case "edit_profile":
        return const Color(0xFF6C5CE7); // violet
      case "reset_password":
        return const Color(0xFFFDCB6E); // kuning
      case "delete_account":
        return const Color(0xFFD63031); // merah gelap
      case "object_detection":
        return const Color(0xFF00A8FF); // sky blue
      case "profile":
        return const Color(0xFF795548); // coklat
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,

        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),

        title: Text(
          "Riwayat Aktivitas",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),

        centerTitle: false,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.activities.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history_rounded,
                  size: 90,
                  color: Colors.grey.shade400,
                ),

                const SizedBox(height: 16),

                Text(
                  "Belum Ada Aktivitas",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Aktivitas belajar akan muncul di sini",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: controller.activities.length,
          itemBuilder: (context, index) {
            final item = controller.activities[index];

            final type = item["activityType"] ?? "";

            final color = getColor(type);

            DateTime date = DateTime.parse(item["createdAt"]).toLocal();

            const hari = [
              "Senin",
              "Selasa",
              "Rabu",
              "Kamis",
              "Jumat",
              "Sabtu",
              "Minggu",
            ];

            const bulan = [
              "Januari",
              "Februari",
              "Maret",
              "April",
              "Mei",
              "Juni",
              "Juli",
              "Agustus",
              "September",
              "Oktober",
              "November",
              "Desember",
            ];

            String tanggal =
                "${hari[date.weekday - 1]}, ${date.day} ${bulan[date.month - 1]} ${date.year}";

            String waktu =
                "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

            return Container(
              margin: const EdgeInsets.only(bottom: 16),

              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),

                border: Border.all(
                  color: AppColors.primary.withOpacity(0.15),
                  width: 1,
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 18,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(getIcon(type), color: color, size: 28),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item["title"] ?? "",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.schedule_rounded,
                                      size: 13,
                                      color: Colors.grey.shade500,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      waktu,
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            Text(
                              item["detail"] ?? "",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),

                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Divider(color: Colors.grey.shade200),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      if (item["score"] != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.emoji_events_rounded,
                                size: 16,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${item["score"]}",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                      const Spacer(),

                      Text(
                        tanggal,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
