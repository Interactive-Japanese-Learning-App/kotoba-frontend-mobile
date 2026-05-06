import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/app_snackbar.dart';

class LoginController extends GetxController {
  /// INPUT
  final emailC = TextEditingController();
  final passC = TextEditingController();

  /// SHOW PASSWORD
  final isHidden = true.obs;

  /// LOADING (buat future API)
  final isLoading = false.obs;

  /// TOGGLE PASSWORD
  void togglePassword() {
    isHidden.value = !isHidden.value;
  }

  /// LOGIN ACTION
  void login() async {
    final email = emailC.text.trim();
    final pass = passC.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      AppSnackbar.show(title: "Error", message: "Email & Password wajib diisi");
      return;
    }

    isLoading.value = true;

    /// simulasi API
    await Future.delayed(const Duration(seconds: 1));

    isLoading.value = false;

    final username = email.split('@').first;

    /// masuk ke main sambil bawa data (mock, tanpa simpan permanen)
    Get.offAllNamed(
      Routes.MAIN,
      arguments: {
        'email': email,
        'username': username,
      },
    );
  }

  /// GOOGLE LOGIN (placeholder)
  void loginWithGoogle() {
    Get.snackbar("Info", "Google Login belum tersedia");
  }

  /// KE REGISTER
  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();
    super.onClose();
  }
}