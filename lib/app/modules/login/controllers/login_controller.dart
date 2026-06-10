import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

  /// STORAGE
  final box = GetStorage();

  /// TOGGLE PASSWORD
  void togglePassword() {
    isHidden.value = !isHidden.value;
  }

  /// LOGIN ACTION
  Future<void> login() async {
    final email = emailC.text.trim();

    final pass = passC.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      AppSnackbar.show(title: "Error", message: "Email & Password wajib diisi");

      return;
    }

    try {
      isLoading.value = true;

      final result = await ApiService.login(email: email, password: pass);

      if (result['success'] == true) {
        final token = result['token'];
        final user = result['user'];
        await box.write('token', token);
        await box.write('userId', user['_id']);
        await box.write('email', user['email']);
        await box.write('username', user['email'].split('@').first);

        AppSnackbar.show(title: "Berhasil", message: "Login berhasil");

        Get.offAllNamed(
          Routes.MAIN,
          arguments: {
            'id': user['_id'],
            'email': user['email'],
            'username': user['email'].split('@').first,
          },
        );
      } else {
        AppSnackbar.show(
          title: "Login Gagal",
          message: result['message'] ?? "Login gagal",
        );
      }
    } catch (e) {
      AppSnackbar.show(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// GOOGLE LOGIN
  void loginWithGoogle() {
    Get.snackbar("Info", "Google Login belum tersedia");
  }

  /// KE REGISTER
  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  @override
  void onClose() {
    // NOTE:
    // TextEditingController disposal is handled by GetX widgets lifecycle.
    // Disposing here can cause: "A TextEditingController was used after being disposed"
    // when input focus/gestures complete after controller is closed.
    super.onClose();
  }
}
