import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/reset_password_controller.dart';
import '../../../data/theme/app_colors.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

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

              /// TITLE
              Text(
                "KATA SANDI BARU",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 30),

              /// PASSWORD BARU
              Obx(
                () => TextField(
                  controller: controller.passC,
                  obscureText: controller.isHidden.value,
                  decoration: _inputDecoration("Kata Sandi Baru").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.primary,
                      ),
                      onPressed: () => controller.isHidden.toggle(),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// KONFIRMASI PASSWORD
              Obx(
                () => TextField(
                  controller: controller.confirmC,
                  obscureText: controller.isHiddenConfirm.value,

                  decoration: _inputDecoration("Konfirmasi Kata Sandi Baru")
                      .copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isHiddenConfirm.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.primary,
                          ),
                          onPressed: () => controller.isHiddenConfirm.toggle(),
                        ),
                      ),
                ),
              ),

              const SizedBox(height: 25),

              /// BUTTON SIMPAN
              Obx(
                () => SizedBox(
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
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.resetPassword,
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Simpan", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

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
