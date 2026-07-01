import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/theme/app_colors.dart';
import '../controllers/profile_controller.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      /// HEADER
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,

        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),

        title: Text(
          "Edit Profil",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),

        centerTitle: false,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              /// FOTO PROFIL
              Center(
                child: Column(
                  children: [
                    Obx(() {
                      final hasPhoto = controller.photoUrl.value.isNotEmpty;

                      final initial = controller.username.value.isNotEmpty
                          ? controller.username.value[0].toUpperCase()
                          : "?";

                      return CircleAvatar(
                        radius: 45,
                        backgroundColor: AppColors.primary,
                        backgroundImage: hasPhoto
                            ? NetworkImage(controller.photoUrl.value)
                            : null,
                        child: hasPhoto
                            ? null
                            : Text(
                                initial,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      );
                    }),

                    const SizedBox(height: 12),

                    Obx(
                      () => Text(
                        controller.username.value.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              /// EMAIL
              _input(controller.emailController, "Email"),

              const SizedBox(height: 15),

              /// PASSWORD LAMA
              Obx(
                () => _inputPassword(
                  controller.oldPasswordController,
                  "Kata Sandi Lama",
                  controller.oldPassObscure.value,
                  () => controller.oldPassObscure.toggle(),
                ),
              ),

              const SizedBox(height: 15),

              /// PASSWORD BARU
              Obx(
                () => _inputPassword(
                  controller.newPasswordController,
                  "Kata Sandi Baru",
                  controller.newPassObscure.value,
                  () => controller.newPassObscure.toggle(),
                ),
              ),

              const SizedBox(height: 15),

              /// KONFIRMASI PASSWORD
              Obx(
                () => _inputPassword(
                  controller.confirmPasswordController,
                  "Konfirmasi Kata Sandi",
                  controller.confirmPassObscure.value,
                  () => controller.confirmPassObscure.toggle(),
                ),
              ),

              const SizedBox(height: 30),

              /// BUTTON SIMPAN
              Obx(
                () => Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.submitProfile,
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Simpan",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          controller.confirmDeleteAccount();
                        },
                        child: const Text(
                          "Hapus Akun",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // INPUT
  Widget _input(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: TextStyle(color: Colors.grey[600]),

        filled: true,
        fillColor: AppColors.neutral,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),

          borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
        ),
      ),
    );
  }

  // INPUT PASSWORD
  Widget _inputPassword(
    TextEditingController controller,
    String hint,
    bool obscure,
    VoidCallback toggle,
  ) {
    return TextField(
      controller: controller,
      obscureText: obscure,

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: TextStyle(color: Colors.grey[600]),

        filled: true,
        fillColor: AppColors.neutral,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),

          borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
        ),

        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,

            color: AppColors.primary,
          ),

          onPressed: toggle,
        ),
      ),
    );
  }
}
