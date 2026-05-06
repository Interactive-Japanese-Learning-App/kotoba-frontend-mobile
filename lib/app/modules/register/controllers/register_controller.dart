import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {

  /// TEXT CONTROLLER
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final confirmC = TextEditingController();

  /// OBSCURE
  final isHiddenPass = true.obs;
  final isHiddenConfirm = true.obs;

  /// LOADING
  final isLoading = false.obs;

  /// TOGGLE PASSWORD
  void togglePass() {
    isHiddenPass.toggle();
  }

  void toggleConfirm() {
    isHiddenConfirm.toggle();
  }

  /// REGISTER ACTION
  void register() {
    final email = emailC.text.trim();
    final pass = passC.text.trim();
    final confirm = confirmC.text.trim();

    /// VALIDASI
    if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      Get.snackbar("Error", "Semua field wajib diisi");
      return;
    }

    if (!email.contains("@")) {
      Get.snackbar("Error", "Email tidak valid");
      return;
    }

    if (pass.length < 6) {
      Get.snackbar("Error", "Password minimal 6 karakter");
      return;
    }

    if (pass != confirm) {
      Get.snackbar("Error", "Password tidak sama");
      return;
    }

    /// SIMULASI LOADING
    isLoading.value = true;

    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;

      Get.snackbar("Berhasil", "Akun berhasil dibuat");

      /// PINDAH KE LOGIN
      Get.offAllNamed(Routes.LOGIN);
    });
  }

  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();
    confirmC.dispose();
    super.onClose();
  }
}