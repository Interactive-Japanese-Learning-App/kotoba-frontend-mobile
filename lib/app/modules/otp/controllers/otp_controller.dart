import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/app_snackbar.dart';

class OtpController extends GetxController {
  final otpC = TextEditingController();

  final isLoading = false.obs;
  final isResending = false.obs;

  // Countdown 1 menit
  final RxInt secondsRemaining = 60.obs;
  final RxBool canResend = false.obs;

  Timer? _timer;

  late String email;

  @override
  void onInit() {
    super.onInit();

    email = Get.arguments['email'];

    // Mulai countdown saat halaman OTP dibuka
    startCountdown();
  }

  @override
  void onClose() {
    otpC.dispose();
    _timer?.cancel();
    super.onClose();
  }

  void startCountdown() {
    _timer?.cancel();

    secondsRemaining.value = 60;
    canResend.value = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final next = secondsRemaining.value - 1;
      secondsRemaining.value = next;

      if (next <= 0) {
        timer.cancel();
        canResend.value = true;
      }
    });
  }

  String get formattedTime {
    final s = secondsRemaining.value;
    final mm = (s ~/ 60).toString().padLeft(2, '0');
    final ss = (s % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  Future<void> verifyOtp() async {
    if (otpC.text.length != 6) {
      AppSnackbar.show(title: "Error", message: "OTP harus 6 digit");
      return;
    }

    try {
      isLoading.value = true;

      final result = await ApiService.verifyOtp(
        email: email,
        otp: otpC.text.trim(),
      );

      if (result['success'] == true) {
        AppSnackbar.show(
          title: "Berhasil",
          message: "Email berhasil diverifikasi",
        );

        isLoading.value = false;
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      AppSnackbar.show(title: "Error", message: result['message']);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      AppSnackbar.show(title: "Error", message: e.toString());
    }
  }

  Future<void> resendOtp() async {
    if (!canResend.value) return;

    try {
      isResending.value = true;

      final result = await ApiService.resendOtp(email: email);

      if (result['success'] == true) {
        AppSnackbar.show(title: 'Berhasil', message: 'OTP berhasil dikirim ulang');
        startCountdown();
        otpC.clear();
      } else {
        AppSnackbar.show(
          title: 'Error',
          message: result['message'] ?? 'Gagal mengirim ulang OTP',
        );
      }

      isResending.value = false;
    } catch (e) {
      isResending.value = false;
      AppSnackbar.show(title: 'Error', message: e.toString());
    }
  }


}

