import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/api_service.dart';
import '../../../widgets/app_snackbar.dart';
import '../../../routes/app_pages.dart';

class ForgotPasswordController extends GetxController {

  final emailC = TextEditingController();

  final isLoading = false.obs;

  Future<void> sendOtp() async {

    final email = emailC.text.trim();

    if (email.isEmpty) {

      AppSnackbar.show(
        title: "Error",
        message: "Email wajib diisi",
      );

      return;
    }

    try {

      isLoading.value = true;

      final result =
          await ApiService.forgotPassword(
        email: email,
      );

      if (result['success']) {

        AppSnackbar.show(
          title: "Berhasil",
          message: result['message'],
        );

        Get.toNamed(
          Routes.OTP,
          arguments: {
            "email": email,
            "isReset": true,
          },
        );

      } else {

        AppSnackbar.show(
          title: "Error",
          message: result['message'],
        );

      }

    } finally {

      isLoading.value = false;

    }
  }

  @override
  void onClose() {
    emailC.dispose();
    super.onClose();
  }
}