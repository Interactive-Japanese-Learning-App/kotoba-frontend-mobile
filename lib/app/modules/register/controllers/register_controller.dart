import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/app_snackbar.dart';
import '../../../data/services/api_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RegisterController extends GetxController {
  /// TEXT CONTROLLER
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final confirmC = TextEditingController();

  /// OBSCURE
  final isHiddenPass = true.obs;
  final isHiddenConfirm = true.obs;

  /// LOADING
  final isLoading = false.obs;

  /// STORAGE
  final box = GetStorage();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID'],
    scopes: ['email'],
    forceCodeForRefreshToken: true,
  );

  /// TOGGLE PASSWORD
  void togglePass() {
    isHiddenPass.toggle();
  }

  void toggleConfirm() {
    isHiddenConfirm.toggle();
  }

  /// REGISTER ACTION
  Future<void> register() async {
    if (isLoading.value) return;
    final email = emailC.text.trim();
    final pass = passC.text.trim();
    final confirm = confirmC.text.trim();

    /// VALIDASI
    if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      AppSnackbar.show(title: "Error", message: "Semua kolom wajib diisi");

      return;
    }

    if (!GetUtils.isEmail(email)) {
      AppSnackbar.show(title: "Error", message: "Email tidak valid");

      return;
    }

    if (pass.length < 8) {
      AppSnackbar.show(
        title: "Error",
        message: "Kata sandi minimal 8 karakter",
      );

      return;
    }

    final hasUppercase = RegExp(r'[A-Z]').hasMatch(pass);

    final hasLowercase = RegExp(r'[a-z]').hasMatch(pass);

    final hasNumber = RegExp(r'[0-9]').hasMatch(pass);

    if (!hasUppercase || !hasLowercase || !hasNumber) {
      AppSnackbar.show(
        title: "Error",
        message:
            "Kata sandi harus memiliki huruf besar, huruf kecil, dan angka",
      );

      return;
    }

    if (pass != confirm) {
      AppSnackbar.show(title: "Error", message: "Kata sandi tidak sama");

      return;
    }
    try {
      isLoading.value = true;

      final result = await ApiService.register(email: email, password: pass);

      print(result);

      if (result['success'] == true) {
        AppSnackbar.show(
          title: "Berhasil",
          message: result['message'] ?? "Berhasil",
        );

        Get.toNamed(Routes.OTP, arguments: {"email": email});
      } else {
        AppSnackbar.show(
          title: "Error",
          message: result['message'] ?? "Registrasi gagal",
        );
      }
    } catch (e) {
      AppSnackbar.show(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// GOOGLE REGISTER ACTION
  Future<void> registerWithGoogle() async {
    try {
      isLoading.value = true;

      // Paksa membersihkan sisa login otomatis lama
      await _googleSignIn.signOut();

      // 1. Munculkan dialog pilihan akun Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        isLoading.value = false;
        return;
      }

      // 2. Ambil detail autentikasi Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        AppSnackbar.show(
          title: "Error",
          message: "Gagal mengamankan ID Token dari SDK Google",
        );
        isLoading.value = false;
        return;
      }

      // 3. Kirim ID Token ke endpoint Google Login backend Node.js kamu
      // Biasanya alur Google Sign-In langsung otomatis membuat akun jika email belum terdaftar
      final result = await ApiService.loginWithGoogle(idToken: idToken);

      if (result['success'] == true) {
        final token = result['token'];
        final user = result['user'];

        // Simpan credentials ke lokal HP
        await box.write('token', token);
        await box.write('userId', user['_id']);
        await box.write('email', user['email']);
        await box.write('username', user['email'].split('@').first);
        await ApiService.saveActivity(
          userId: user['_id'],
          activityType: "register",
          title: "Registrasi Akun",
          detail: "Pengguna mendaftar menggunakan akun Google",
        );

        AppSnackbar.show(title: "Berhasil", message: "Daftar Google Berhasil");

        // Alihkan user langsung masuk ke halaman Utama
        Get.offAllNamed(
          Routes.MAIN,
          arguments: {
            'id': user['_id'],
            'email': user['email'],
            'username': user['email'].split('@').first,
          },
        );
      } else {
        AppSnackbar.show(
          title: "Daftar Gagal",
          message: result['message'] ?? "Gagal memverifikasi akun ke backend",
        );
      }
    } catch (e) {
      AppSnackbar.show(title: "Error Autentikasi", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();
    confirmC.dispose();
    super.onClose();
  }
}
