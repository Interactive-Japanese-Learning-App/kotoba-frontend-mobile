import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/app_snackbar.dart';

class ResetPasswordController extends GetxController {
  final isHidden = true.obs;
  final isHiddenConfirm = true.obs;

  final passC = TextEditingController();

  final confirmC = TextEditingController();

  final isLoading = false.obs;

  late String email;

  @override
  void onInit() {
    super.onInit();

    email = Get.arguments['email'];
  }

  Future<void> resetPassword() async {
    if (passC.text != confirmC.text) {
      AppSnackbar.show(title: "Error", message: "Kata sandi tidak sama");

      return;
    }

    try {
      isLoading.value = true;

      final otp = Get.arguments['otp'];

      if (otp == null || otp.toString().isEmpty) {
        AppSnackbar.show(
          title: "Error",
          message: "OTP tidak ditemukan. Silakan ulangi dari awal.",
        );
        return;
      }

      final result = await ApiService.resetPassword(
        email: email,
        otp: otp.toString().trim(),
        password: passC.text.trim(),
      );

      if (result['success']) {
        AppSnackbar.show(title: "Berhasil", message: result['message']);

        Get.offAllNamed(Routes.LOGIN);
      } else {
        AppSnackbar.show(title: "Error", message: result['message']);
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    passC.dispose();

    confirmC.dispose();

    super.onClose();
  }
}
