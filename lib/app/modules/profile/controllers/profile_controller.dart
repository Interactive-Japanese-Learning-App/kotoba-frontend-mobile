import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kotoba_app/app/data/theme/app_colors.dart';

import '../../../routes/app_pages.dart';
import '../../../data/services/api_service.dart';

class ProfileController extends GetxController {

  /// USER DATA
  final RxString username =
      "ranifa".obs;

  final RxString email =
      "ranifa@gmail.com".obs;

  final RxString userId =
      ''.obs;

  /// FORM CONTROLLER
  final emailController =
      TextEditingController();

  final oldPasswordController =
      TextEditingController();

  final newPasswordController =
      TextEditingController();

  final confirmPasswordController =
      TextEditingController();

  /// PASSWORD VISIBILITY
  final oldPassObscure =
      true.obs;

  final newPassObscure =
      true.obs;

  final confirmPassObscure =
      true.obs;

  /// LOADING
  final isLoading =
      false.obs;

  @override
  void onInit() {

    super.onInit();

    _loadArguments();
    _syncEmailToForm();
  }

  // LOAD ARGUMENTS
  void _loadArguments() {

    final args =
        Get.arguments;

    if (args is Map<String, dynamic>) {

      final idArg =
          args['id']
                  ?.toString() ??
              '';

      final emailArg =
          args['email']
                  ?.toString() ??
              '';

      final usernameArg =
          args['username']
                  ?.toString() ??
              '';

      if (idArg.isNotEmpty) {

        userId.value =
            idArg;
      }

      if (usernameArg
          .isNotEmpty) {

        username.value =
            usernameArg;
      }

      if (emailArg
          .isNotEmpty) {

        email.value =
            emailArg;
      }

      if (usernameArg.isEmpty &&
          emailArg.contains('@')) {

        username.value =
            emailArg
                .split('@')
                .first;
      }
    }
  }

  // SYNC EMAIL
  void _syncEmailToForm() {

    emailController.text =
        email.value;
  }

  // INIT EDIT PROFILE
  void initEditProfile() {

    _syncEmailToForm();

    oldPasswordController
        .clear();

    newPasswordController
        .clear();

    confirmPasswordController
        .clear();
  }

  // SNACKBAR
  void showSnackbar(
    String title,
    String message,
  ) {

    Get.snackbar(

      title,
      message,

      snackPosition:
          SnackPosition.TOP,

      backgroundColor:
          AppColors.primary,

      colorText:
          Colors.white,

      margin:
          const EdgeInsets.all(
        16,
      ),

      borderRadius: 12,

      duration:
          const Duration(
        seconds: 2,
      ),
    );
  }

  // NAVIGATION
  void goEditProfile() {

    initEditProfile();

    Get.toNamed(
      Routes.EDIT_PROFILE,
      arguments: {

        'id':
            userId.value,

        'email':
            email.value,

        'username':
            username.value,
      },
    );
  }

  void goAboutApp() {

    Get.toNamed(
      Routes.ABOUT_APP,
    );
  }

  // SUBMIT PROFILE
  Future<void>
      submitProfile() async {

    if (emailController.text
        .trim()
        .isEmpty) {

      showSnackbar(
        "Error",
        "Email tidak boleh kosong",
      );

      return;
    }

    if (!GetUtils.isEmail(
      emailController.text
          .trim(),
    )) {

      showSnackbar(
        "Error",
        "Format email tidak valid",
      );

      return;
    }

    final hasPasswordInput =

        oldPasswordController
                .text
                .isNotEmpty ||

            newPasswordController
                .text
                .isNotEmpty ||

            confirmPasswordController
                .text
                .isNotEmpty;

    if (hasPasswordInput) {

      final valid =
          _validatePassword();

      if (!valid) return;
    }

    try {

      isLoading.value =
          true;

      final result =
          await ApiService
              .updateProfile(

        id: userId.value,

        email:
            emailController
                .text
                .trim(),

        password:
            newPasswordController
                    .text
                    .isEmpty
                ? oldPasswordController
                    .text
                : newPasswordController
                    .text,
      );

      if (result['success'] ==
          true) {

        email.value =
            emailController
                .text
                .trim();

        username.value =
            emailController
                .text
                .trim()
                .split('@')
                .first;

        Get.back();

        showSnackbar(
          "Berhasil",
          "Profil berhasil diperbarui",
        );

      } else {

        showSnackbar(
          "Error",
          result['message'],
        );
      }

    } catch (e) {

      showSnackbar(
        "Error",
        e.toString(),
      );

    } finally {

      isLoading.value =
          false;
    }
  }

  // VALIDATE PASSWORD
  bool _validatePassword() {

    if (oldPasswordController
            .text
            .isEmpty ||

        newPasswordController
            .text
            .isEmpty ||

        confirmPasswordController
            .text
            .isEmpty) {

      showSnackbar(
        "Error",
        "Semua field password harus diisi",
      );

      return false;
    }

    if (newPasswordController
            .text
            .length <
        8) {

      showSnackbar(
        "Error",
        "Password minimal 8 karakter",
      );

      return false;
    }

    if (newPasswordController
            .text !=
        confirmPasswordController
            .text) {

      showSnackbar(
        "Error",
        "Konfirmasi password tidak cocok",
      );

      return false;
    }

    return true;
  }

  // LOGOUT
  void logout() {

    Get.defaultDialog(

      title: "Keluar",

      backgroundColor:
          Colors.white,

      radius: 20,

      titleStyle:
          const TextStyle(
        fontSize: 20,
        fontWeight:
            FontWeight.bold,
      ),

      middleText:
          "Yakin ingin keluar dari akun?",

      middleTextStyle:
          const TextStyle(
        color: Colors.grey,
        fontSize: 14,
      ),

      confirm:
          ElevatedButton(

        style:
            ElevatedButton
                .styleFrom(

          backgroundColor:
              AppColors
                  .danger,

          foregroundColor:
              Colors.white,

          shape:
              RoundedRectangleBorder(

            borderRadius:
                BorderRadius
                    .circular(
              12,
            ),
          ),
        ),

        onPressed: () {

          Get.back();

          showSnackbar(
            "Keluar",
            "Berhasil logout",
          );

          Future.delayed(

            const Duration(
              milliseconds:
                  700,
            ),

            () {

              Get.offAllNamed(
                Routes.LOGIN,
              );
            },
          );
        },

        child:
            const Text("Ya"),
      ),

      cancel: TextButton(

        onPressed:
            () => Get.back(),

        child: Text(

          "Tidak",

          style: TextStyle(
            color:
                AppColors
                    .danger,
          ),
        ),
      ),
    );
  }

  // DISPOSE
  @override
  void onClose() {

    emailController.dispose();

    oldPasswordController
        .dispose();

    newPasswordController
        .dispose();

    confirmPasswordController
        .dispose();

    super.onClose();
  }
}