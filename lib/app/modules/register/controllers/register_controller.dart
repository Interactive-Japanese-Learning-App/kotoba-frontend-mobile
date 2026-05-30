import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/app_snackbar.dart';
import '../../../data/services/api_service.dart';

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
  Future<void> register() async {

    final email = emailC.text.trim();
    final pass = passC.text.trim();
    final confirm = confirmC.text.trim();

    /// VALIDASI
    if (email.isEmpty ||
        pass.isEmpty ||
        confirm.isEmpty) {

      AppSnackbar.show(
        title: "Error",
        message: "Semua field wajib diisi",
      );

      return;
    }

    if (!GetUtils.isEmail(email)) {

      AppSnackbar.show(
        title: "Error",
        message: "Email tidak valid",
      );

      return;
    }

    if (pass.length < 8) {

      AppSnackbar.show(
        title: "Error",
        message:
            "Password minimal 8 karakter",
      );

      return;
    }

    final hasUppercase =
        RegExp(r'[A-Z]').hasMatch(pass);

    final hasLowercase =
        RegExp(r'[a-z]').hasMatch(pass);

    final hasNumber =
        RegExp(r'[0-9]').hasMatch(pass);

    if (!hasUppercase ||
        !hasLowercase ||
        !hasNumber) {

      AppSnackbar.show(
        title: "Error",
        message:
            "Password harus memiliki huruf besar, huruf kecil, dan angka",
      );

      return;
    }

    if (pass != confirm) {

      AppSnackbar.show(
        title: "Error",
        message:
            "Kata sandi tidak sama",
      );

      return;
    }

    try {

      isLoading.value = true;

      final result =
          await ApiService.register(
        email: email,
        password: pass,
      );

      if (result['success'] == true) {

        AppSnackbar.show(
          title: "Berhasil",
          message:
              result['message'] ??
              "Register berhasil",
        );

        Get.offNamed(
          Routes.LOGIN,
        );

      } else {

        AppSnackbar.show(
          title: "Error",
          message:
              result['message'] ??
              "Register gagal",
        );

      }

    } catch (e) {

      AppSnackbar.show(
        title: "Error",
        message: e.toString(),
      );

    } finally {

      isLoading.value = false;

    }
  }

  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();
    confirmC.dispose();
    super.onClose();
  }
}