import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kotoba_app/app/data/theme/app_colors.dart';
import 'package:kotoba_app/app/widgets/app_snackbar.dart';

import '../../../routes/app_pages.dart';
import '../../../data/services/api_service.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  /// USER DATA
  final RxString username = ''.obs;

  final RxString email = ''.obs;

  final RxString userId = ''.obs;
  final RxString photoUrl = ''.obs;

  /// FORM CONTROLLER
  final emailController = TextEditingController();

  final oldPasswordController = TextEditingController();

  final newPasswordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  /// PASSWORD VISIBILITY
  final oldPassObscure = true.obs;

  final newPassObscure = true.obs;

  final confirmPassObscure = true.obs;

  /// LOADING
  final isLoading = false.obs;

  // STORAGE
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();

    _loadArguments();
    _syncEmailToForm();
  }

  // LOAD ARGUMENTS
  void _loadArguments() {
    userId.value = box.read('userId') ?? '';
    email.value = box.read('email') ?? '';
    username.value = box.read('username') ?? '';
    photoUrl.value = box.read('photoUrl') ?? '';
  }

  // SYNC EMAIL
  void _syncEmailToForm() {
    emailController.text = email.value;
  }

  // INIT EDIT PROFILE
  void initEditProfile() {
    _syncEmailToForm();

    oldPasswordController.clear();

    newPasswordController.clear();

    confirmPasswordController.clear();
  }

  // SNACKBAR
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

  // NAVIGATION
  void goEditProfile() {
    initEditProfile();

    Get.toNamed(
      Routes.EDIT_PROFILE,
      arguments: {
        'id': userId.value,

        'email': email.value,

        'username': username.value,
      },
    );
  }

  void goAboutApp() {
    Get.toNamed(Routes.ABOUT_APP);
  }

  void goActivityLog() {
    print("CLICK ACTIVITY");
    Get.toNamed(Routes.ACTIVITY_LOG);
  }

  // SUBMIT PROFILE
  Future<void> submitProfile() async {
    if (emailController.text.trim().isEmpty) {
      showSnackbar("Error", "Email tidak boleh kosong");

      return;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      showSnackbar("Error", "Format email tidak valid");
      return;
    }

    final newEmail = emailController.text.trim();

    final emailChanged = newEmail != email.value;

    final passwordChanged =
        oldPasswordController.text.isNotEmpty ||
        newPasswordController.text.isNotEmpty ||
        confirmPasswordController.text.isNotEmpty;

    if (!emailChanged && !passwordChanged) {
      showSnackbar("Info", "Tidak ada perubahan data");
      return;
    }

    final hasPasswordInput =
        oldPasswordController.text.isNotEmpty ||
        newPasswordController.text.isNotEmpty ||
        confirmPasswordController.text.isNotEmpty;

    if (hasPasswordInput) {
      final valid = _validatePassword();

      if (!valid) return;
    }

    try {
      isLoading.value = true;

      final result = await ApiService.updateProfile(
        id: userId.value,

        email: emailController.text.trim(),

        password: newPasswordController.text.isEmpty
            ? oldPasswordController.text
            : newPasswordController.text,
      );

      if (result['success'] == true) {
        await ApiService.saveEditProfileActivity(
          userId: userId.value,
          email: emailController.text.trim(),
        );

        email.value = emailController.text.trim();
        username.value = emailController.text.trim().split('@').first;

        await box.write('email', email.value);
        await box.write('username', username.value);

        _loadArguments();
        update();

        Get.back();

        showSnackbar("Berhasil", "Profil berhasil diperbarui");
      } else {
        showSnackbar("Error", result['message']);
      }
    } catch (e) {
      showSnackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // VALIDATE PASSWORD
  bool _validatePassword() {
    if (oldPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showSnackbar("Error", "Semua field kata sandi harus diisi");

      return false;
    }

    if (newPasswordController.text.length < 8) {
      showSnackbar("Error", "Kata sandi minimal 8 karakter");

      return false;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      showSnackbar("Error", "Konfirmasi kata sandi tidak cocok");

      return false;
    }

    return true;
  }

  void confirmDeleteAccount() {
    Get.defaultDialog(
      title: "Hapus Akun",

      backgroundColor: Colors.white,

      radius: 20,

      titleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

      middleText: "Yakin ingin menghapus akun?",

      middleTextStyle: const TextStyle(color: Colors.grey, fontSize: 14),

      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.danger,

          foregroundColor: Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        onPressed: () async {
          Get.back();

          await deleteAccount();
        },

        child: const Text("Ya"),
      ),

      cancel: TextButton(
        onPressed: () => Get.back(),

        child: Text("Tidak", style: TextStyle(color: AppColors.danger)),
      ),
    );
  }

  //DELETE AKUN
  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;

      final userId = box.read('userId');
      final email = box.read('email');

      // SIMPAN ACTIVITY
      await ApiService.saveDeleteAccountActivity(userId: userId, email: email);

      final result = await ApiService.deleteAccount(userId: userId);

      if (result['success'] == true) {
        await box.erase();

        AppSnackbar.show(title: "Berhasil", message: "Akun berhasil dihapus");

        Get.offAllNamed(Routes.LOGIN);
      } else {
        AppSnackbar.show(title: "Error", message: result['message']);
      }
    } catch (e) {
      AppSnackbar.show(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // LOGOUT
  void logout() {
    Get.defaultDialog(
      title: "Keluar",

      backgroundColor: Colors.white,

      radius: 20,

      titleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

      middleText: "Yakin ingin keluar dari akun?",

      middleTextStyle: const TextStyle(color: Colors.grey, fontSize: 14),

      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.danger,

          foregroundColor: Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        onPressed: () async {
          await ApiService.saveLogoutActivity(
            userId: userId.value,
            email: email.value,
          );
          await box.remove('token');
          await box.remove('userId');
          await box.remove('email');
          await box.remove('username');
          await box.remove('photoUrl');

          Get.back();

          showSnackbar("Keluar", "Berhasil keluar");

          Future.delayed(const Duration(milliseconds: 700), () {
            Get.offAllNamed(Routes.LOGIN);
          });
        },
        child: const Text("Ya"),
      ),

      cancel: TextButton(
        onPressed: () => Get.back(),

        child: Text("Tidak", style: TextStyle(color: AppColors.danger)),
      ),
    );
  }
}
