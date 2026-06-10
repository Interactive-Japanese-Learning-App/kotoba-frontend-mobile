import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/otp_controller.dart';
import '../../../data/theme/app_colors.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(controller.isReset ? 'OTP Reset Password' : 'Verifikasi OTP'),
        foregroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                controller.isReset ? 'RESET PASSWORD' : 'VERIFIKASI EMAIL',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Masukkan kode OTP yang telah dikirim ke email Anda untuk melanjutkan proses verifikasi akun.',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 28),

              TextField(
                controller: controller.otpC,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.neutral,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  counterText: '',
                ),
              ),

              const SizedBox(height: 14),

              Obx(
                () => Text(
                  'OTP bisa dikirim ulang dalam ${controller.formattedTime}',
                  style: TextStyle(
                    fontSize: 12,
                    color: controller.canResend.value
                        ? AppColors.danger
                        : Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // BUTTON KIRIM ULANG (style senada seperti tombol welcome/login/register)
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: controller.canResend.value
                            ? AppColors.danger
                            : Colors.grey[400]!,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      foregroundColor: controller.canResend.value
                          ? AppColors.danger
                          : Colors.grey,
                    ),
                    onPressed: controller.canResend.value
                        ? controller.isResending.value
                              ? null
                              : controller.resendOtp
                        : null,
                    child: controller.isResending.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Kirim ulang OTP',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // BUTTON VERIFIKASI
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
                        : controller.verifyOtp,
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Verifikasi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
