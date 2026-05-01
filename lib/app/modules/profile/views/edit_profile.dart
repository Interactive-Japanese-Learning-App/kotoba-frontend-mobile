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

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔷 BACK + TITLE
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios),
                    color: AppColors.primary,
                    padding: EdgeInsets.zero,
                  ),

                  const SizedBox(width: 5),

                  Text(
                    "Edit Profil",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// 🔷 FOTO PROFIL
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: AppColors.neutral,
                      child: const Icon(
                        Icons.person,
                        size: 50,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Ubah Foto",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// 🔷 EMAIL
              _input(
                controller.emailController,
                "Email",
              ),

              const SizedBox(height: 15),

              /// 🔷 PASSWORD LAMA
              Obx(
                () => _inputPassword(
                  controller.oldPasswordController,
                  "Kata Sandi Lama",
                  controller.oldPassObsecure.value,
                  () => controller.oldPassObsecure.toggle(),
                ),
              ),

              const SizedBox(height: 15),

              /// 🔷 PASSWORD BARU
              Obx(
                () => _inputPassword(
                  controller.newPasswordController,
                  "Kata Sandi Baru",
                  controller.newPassObsecure.value,
                  () => controller.newPassObsecure.toggle(),
                ),
              ),

              const SizedBox(height: 15),

              /// 🔷 KONFIRMASI PASSWORD
              Obx(
                () => _inputPassword(
                  controller.confirmPasswordController,
                  "Konfirmasi Kata Sandi",
                  controller.confirmPassObsecure.value,
                  () => controller.confirmPassObsecure.toggle(),
                ),
              ),

              const SizedBox(height: 30),

              /// 🔷 BUTTON SIMPAN
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: controller.updateProfile,
                  child: const Text(
                    "Simpan",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔷 INPUT STYLE LOGIN
  Widget _input(
    TextEditingController controller,
    String hint,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey[600],
        ),
        filled: true,
        fillColor: AppColors.neutral,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
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
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1,
          ),
        ),
      ),
    );
  }

  /// 🔷 INPUT PASSWORD STYLE LOGIN
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
        hintStyle: TextStyle(
          color: Colors.grey[600],
        ),
        filled: true,
        fillColor: AppColors.neutral,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
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
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1,
          ),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure
                ? Icons.visibility_off
                : Icons.visibility,
            color: AppColors.primary,
          ),
          onPressed: toggle,
        ),
      ),
    );
  }
}