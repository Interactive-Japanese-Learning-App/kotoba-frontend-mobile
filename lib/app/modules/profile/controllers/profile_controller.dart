import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotoba_app/app/data/theme/app_colors.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  /// USER DATA
  var username = "ranifa".obs;
  var email = "ranifa@gmail.com".obs;

  /// FORM CONTROLLER
  final emailController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  /// OBSCURE STATE
  var oldPassObsecure = true.obs;
  var newPassObsecure = true.obs;
  var confirmPassObsecure = true.obs;

  /// LOADING
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _syncEmailToForm();
  }

  /// SYNC DATA KE FORM
  void _syncEmailToForm() {
    emailController.text = email.value;
  }

  /// DIPANGGIL SAAT MASUK EDIT PROFILE
  void initEditProfile() {
    _syncEmailToForm();

    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  /// SNACKBAR
  void showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  /// NAVIGASI (FIX: JANGAN PAKAI ROUTES YANG BELUM ADA)
  void goEditProfile() {
    Get.toNamed('/profile/edit'); 
  }

  // =====================================================
  // SUBMIT (COMBINE PROFILE + PASSWORD)
  // =====================================================
  void submitProfile() async {
    /// VALIDASI EMAIL
    if (emailController.text.isEmpty) {
      showSnackbar("Error", "Email tidak boleh kosong");
      return;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      showSnackbar("Error", "Format email tidak valid");
      return;
    }

    /// VALIDASI PASSWORD (OPTIONAL)
    if (newPasswordController.text.isNotEmpty ||
        confirmPasswordController.text.isNotEmpty ||
        oldPasswordController.text.isNotEmpty) {
      final valid = _validatePassword();
      if (!valid) return;
    }

    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1)); // simulasi API

    /// UPDATE DATA
    email.value = emailController.text;

    isLoading.value = false;
    Get.back();

    showSnackbar("Success", "Profile berhasil diupdate");
  }

  /// VALIDASI PASSWORD
  bool _validatePassword() {
    if (oldPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showSnackbar("Error", "Semua field password harus diisi");
      return false;
    }

    if (newPasswordController.text.length < 6) {
      showSnackbar("Error", "Password minimal 6 karakter");
      return false;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      showSnackbar("Error", "Password tidak cocok");
      return false;
    }

    return true;
  }

  /// LOGOUT
  void logout() {
    Get.defaultDialog(
      title: "Keluar",
      backgroundColor: Colors.white,
      titleStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      middleText: "Yakin ingin keluar dari akun?",
      middleTextStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      radius: 20,

      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.danger,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Get.back();

          showSnackbar("Keluar", "Berhasil logout");

          Future.delayed(const Duration(milliseconds: 700), () {
            Get.offAllNamed(Routes.LOGIN);
          });
        },
        child: const Text("Ya"),
      ),

      cancel: TextButton(
        onPressed: () => Get.back(),
        child: Text(
          "Tidak",
          style: TextStyle(color: AppColors.danger),
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