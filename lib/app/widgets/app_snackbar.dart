import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/theme/app_colors.dart';

class AppSnackbar {
  static void show({
    required String title,
    required String message,
    SnackPosition snackPosition = SnackPosition.TOP,
    Duration duration = const Duration(seconds: 2),
    EdgeInsets margin = const EdgeInsets.all(16),
    double borderRadius = 12,
    Color backgroundColor = AppColors.primary,
    Color textColor = Colors.white,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: snackPosition,
      backgroundColor: backgroundColor,
      colorText: textColor,
      margin: margin,
      borderRadius: borderRadius,
      duration: duration,
    );
  }
}

