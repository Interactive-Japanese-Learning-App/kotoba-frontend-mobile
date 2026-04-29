import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static final light = ThemeData(
    fontFamily: 'Poppins', 

    scaffoldBackgroundColor: AppColors.white,

    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.warning,
      error: AppColors.danger,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 14),
      titleLarge: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}