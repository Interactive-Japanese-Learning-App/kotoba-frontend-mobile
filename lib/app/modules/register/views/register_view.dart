import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../../../data/theme/app_colors.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),

              /// LOGO
              Image.asset(
                "assets/images/kotoba-logo.png",
                height: 120,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 120),
              ),

              const SizedBox(height: 20),

              /// TITLE
              Text(
                "DAFTAR",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 30),

              /// EMAIL
              TextField(
                controller: controller.emailC,
                decoration: _inputDecoration("Email"),
              ),

              const SizedBox(height: 15),

              /// PASSWORD
              Obx(() => TextField(
                    controller: controller.passC,
                    obscureText: controller.isHiddenPass.value,
                    decoration: _inputDecoration("Kata Sandi").copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isHiddenPass.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.primary,
                        ),
                        onPressed: controller.togglePass,
                      ),
                    ),
                  )),

              const SizedBox(height: 15),

              /// CONFIRM PASSWORD
              Obx(() => TextField(
                    controller: controller.confirmC,
                    obscureText: controller.isHiddenConfirm.value,
                    decoration: _inputDecoration("Konfirmasi Kata Sandi").copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isHiddenConfirm.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.primary,
                        ),
                        onPressed: controller.toggleConfirm,
                      ),
                    ),
                  )),

              const SizedBox(height: 25),

              /// BUTTON DAFTAR (REACTIVE)
              Obx(() => SizedBox(
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
                      onPressed: controller.isLoading.value ? null : controller.register,
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Daftar", style: TextStyle(fontSize: 16)),
                    ),
                  )),

              const SizedBox(height: 20),

              /// GOOGLE BUTTON ACTION
              Column(
                children: [
                  const Text(
                    "atau daftar dengan",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Obx(() => InkWell(
                        borderRadius: BorderRadius.circular(20),
                        // Jika sedang loading, fungsi klik dimatikan
                        onTap: controller.isLoading.value
                            ? null
                            : () => controller.registerWithGoogle(),
                        child: Opacity(
                          opacity: controller.isLoading.value ? 0.5 : 1.0,
                          child: SizedBox(
                            height: 40,
                            child: Image.asset(
                              "assets/images/logo-google.png",
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.g_mobiledata, size: 40),
                            ),
                          ),
                        ),
                      )),
                ],
              ),

              const SizedBox(height: 25),

              /// KE LOGIN
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Sudah punya akun? "),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Text(
                      "Masuk",
                      style: TextStyle(
                        color: AppColors.danger,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// INPUT STYLE
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.neutral,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );
  }
}