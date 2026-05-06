import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/app_snackbar.dart';

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
      AppSnackbar.show(title: "Error", message: "Semua field wajib diisi");
      return;

    }

    if (!email.contains("@")) {
      AppSnackbar.show(title: "Error", message: "Email tidak valid");
      return;

    }

    if (pass.length < 6) {
      AppSnackbar.show(
        title: "Error",
        message: "Password minimal 6 karakter",
      );
      return;
    }


    if (pass != confirm) {
      AppSnackbar.show(title: "Error", message: "Password tidak sama");
      return;

    }

    /// SIMULASI LOADING
    isLoading.value = true;

    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;

      AppSnackbar.show(title: "Berhasil", message: "Akun berhasil dibuat");

      /// PINDAH KE LOGIN (mock: bawa email/username)
      final username = email.split('@').first;
      Get.offNamed(
        Routes.LOGIN,
        arguments: {
          'email': email,
          'username': username,
        },
      );
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

