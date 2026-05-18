import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/app_snackbar.dart';
import 'package:get_storage/get_storage.dart';

class RegisterController extends GetxController {
  final box = GetStorage();

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

    if (!GetUtils.isEmail(email)) {
      AppSnackbar.show(title: "Error", message: "Email tidak valid");
      return;
    }

    if (pass.length < 8) {
      AppSnackbar.show(title: "Error", message: "Password minimal 8 karakter");
      return;
    }

    final hasUppercase = RegExp(r'[A-Z]').hasMatch(pass);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(pass);
    final hasNumber = RegExp(r'[0-9]').hasMatch(pass);

    if (!hasUppercase || !hasLowercase || !hasNumber) {
      AppSnackbar.show(
        title: "Error",
        message:
            "Kata sandi minimal 8 karakter dan harus memiliki huruf besar, huruf kecil, serta angka",
      );
      return;
    }

    if (pass != confirm) {
      AppSnackbar.show(title: "Error", message: "Kata sandi tidak sama");
      return;
    }

    /// SIMULASI LOADING
    isLoading.value = true;

    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;

      /// SIMPAN DATA AKUN
      box.write('email', email);
      box.write('password', pass);

      AppSnackbar.show(title: "Berhasil", message: "Akun berhasil dibuat");

      final username = email.split('@').first;

      Get.offNamed(
        Routes.LOGIN,
        arguments: {'email': email, 'username': username},
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
