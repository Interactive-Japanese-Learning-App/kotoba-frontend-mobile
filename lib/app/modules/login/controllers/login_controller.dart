import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

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
    if (emailC.text.isEmpty || passC.text.isEmpty) {
      Get.snackbar("Error", "Email & Password wajib diisi");
      return;
    }

    isLoading.value = true;

    /// simulasi API
    await Future.delayed(const Duration(seconds: 1));

    isLoading.value = false;

    /// masuk ke main
    Get.offAllNamed(Routes.MAIN);
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