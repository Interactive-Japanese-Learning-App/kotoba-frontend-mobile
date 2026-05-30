import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/app_snackbar.dart';
import '../../../data/services/api_service.dart';

class LoginController extends GetxController {

  /// INPUT
  final emailC = TextEditingController();
  final passC = TextEditingController();

  /// SHOW PASSWORD
  final isHidden = true.obs;

  /// LOADING
  final isLoading = false.obs;

  /// TOGGLE PASSWORD
  void togglePassword() {
    isHidden.value = !isHidden.value;
  }

  /// LOGIN ACTION
  Future<void> login() async {

    final email =
        emailC.text.trim();

    final pass =
        passC.text.trim();

    if (email.isEmpty ||
        pass.isEmpty) {

      AppSnackbar.show(
        title: "Error",
        message:
            "Email & Password wajib diisi",
      );

      return;
    }

    try {

      isLoading.value = true;

      final result =
          await ApiService.login(

        email: email,
        password: pass,

      );

      if (result['success'] == true) {

        final user =
            result['user'];

        AppSnackbar.show(
          title: "Berhasil",
          message:
              "Login berhasil",
        );

        Get.offAllNamed(

          Routes.MAIN,

          arguments: {

            'id':
                user['_id'],

            'email':
                user['email'],

            'username':
                user['email']
                    .split('@')
                    .first,
          },
        );

      } else {

        AppSnackbar.show(
          title: "Login Gagal",
          message:
              result['message'] ??
              "Login gagal",
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

  /// GOOGLE LOGIN
  void loginWithGoogle() {

    Get.snackbar(
      "Info",
      "Google Login belum tersedia",
    );

  }

  /// KE REGISTER
  void goToRegister() {

    Get.toNamed(
      Routes.REGISTER,
    );

  }

  @override
  void onClose() {

    emailC.dispose();
    passC.dispose();

    super.onClose();
  }
}