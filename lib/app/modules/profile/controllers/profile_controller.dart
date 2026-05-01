import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotoba_app/app/data/theme/app_colors.dart';

class ProfileController extends GetxController {
  var username = "User".obs;
  var email = "user@mail.com".obs;

  final emailController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var oldPassObsecure = true.obs;
  var newPassObsecure = true.obs;
  var confirmPassObsecure = true.obs;

  @override
  void onInit() {
    emailController.text = email.value;
    super.onInit();
  }

  /// 🔷 SNACKBAR STYLE
  void showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,

      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      colorText: Colors.black,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 2),
      boxShadows: [],
    );
  }

  /// NAVIGASI
  void goEditProfile() {
    Get.toNamed('/profile/edit');
  }

  /// UPDATE PROFILE
  void updateProfile() {
    email.value = emailController.text;

    Get.back();

    showSnackbar("Success", "Profile berhasil diupdate");
  }

  /// GANTI PASSWORD
  void changePassword() {
    if (newPasswordController.text != confirmPasswordController.text) {
      showSnackbar("Error", "Password tidak cocok");

      return;
    }

    Get.back();

    showSnackbar("Success", "Password berhasil diubah");
  }

  /// LOGOUT
  void logout() {
    Get.defaultDialog(
      title: "Keluar",

      backgroundColor: Colors.white,

      titleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

      middleText: "Yakin ingin keluar dari akun?",

      middleTextStyle: TextStyle(color: Colors.grey, fontSize: 14),

      radius: 24,

      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),

      titlePadding: const EdgeInsets.only(top: 24, left: 24, right: 24),

      barrierDismissible: true,

      /// 🔴 BUTTON YA
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.danger,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        ),

        onPressed: () {
          Get.back();

          showSnackbar("Keluar", "Berhasil keluar dari akun");

          Future.delayed(const Duration(milliseconds: 700), () {
            Get.offAllNamed('/login');
          });
        },

        child: const Text("Ya"),
      ),

      /// 🔴 BUTTON TIDAK
      cancel: TextButton(
        style: TextButton.styleFrom(foregroundColor: AppColors.danger),

        onPressed: () {
          Get.back();
        },

        child: const Text(
          "Tidak",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}
