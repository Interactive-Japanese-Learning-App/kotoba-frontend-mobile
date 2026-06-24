import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/app_snackbar.dart';
import '../../../data/services/api_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginController extends GetxController {
  /// INPUT
  final emailC = TextEditingController();
  final passC = TextEditingController();

  /// SHOW PASSWORD
  final isHidden = true.obs;

  /// LOADING
  final isLoading = false.obs;

  /// STORAGE
  final box = GetStorage();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID'],
    scopes: ['email'],
  );

  /// TOGGLE PASSWORD
  void togglePassword() {
    isHidden.value = !isHidden.value;
  }

  /// LOGIN ACTION
  Future<void> login() async {
    final email = emailC.text.trim();

    final pass = passC.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      AppSnackbar.show(title: "Error", message: "Email & Password wajib diisi");

      return;
    }

    try {
      isLoading.value = true;

      final result = await ApiService.login(email: email, password: pass);

      if (result['success'] == true) {
        final token = result['token'];
        final user = result['user'];
        await box.write('token', token);
        await box.write('userId', user['_id']);
        await box.write('email', user['email']);
        await box.write('username', user['email'].split('@').first);

        await ApiService.saveLoginActivity(
          userId: user['_id'],
          email: user['email'],
        );

        AppSnackbar.show(title: "Berhasil", message: "Login berhasil");

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
          title: "Login Gagal",
          message: result['message'] ?? "Login gagal",
        );
      }
    } catch (e) {
      AppSnackbar.show(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// GOOGLE LOGIN
  // GOOGLE LOGIN ACTION
  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      await _googleSignIn.signOut();
      // 1. Munculkan dialog pilihan akun Google bawaan sistem HP/Emulator
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // Alur dibatalkan oleh pengguna (klik di luar pop-up)
        isLoading.value = false;
        return;
      }

      // 2. Ambil detail autentikasi dari akun Google yang dipilih
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

      // 3. Kirim ID Token tersebut ke API Backend Node.js
      final result = await ApiService.loginWithGoogle(idToken: idToken);

      if (result['success'] == true) {
        final token = result['token'];
        final user = result['user'];

        // Simpan data kredensial baru ke penyimpanan lokal HP (GetStorage)
        await box.write('token', token);
        await box.write('userId', user['_id']);
        await box.write('email', user['email']);
        await box.write('username', user['email'].split('@').first);

        await ApiService.saveLoginActivity(
          userId: user['_id'],
          email: user['email'],
        );

        AppSnackbar.show(title: "Berhasil", message: "Login Google Berhasil");

        // Alihkan user langsung masuk ke Dashboard Utama aplikasi
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
          title: "Login Gagal",
          message:
              result['message'] ?? "Gagal memverifikasi akun ke sistem backend",
        );
      }
    } catch (e) {
      AppSnackbar.show(title: "Error Autentikasi", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// KE REGISTER
  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  Future<void> logout() async {
    try {
      // Memutuskan total hubungan akun Google dari aplikasi agar benar-benar "dilupakan"
      await _googleSignIn.disconnect();

      // Menghapus token dan data user dari penyimpanan HP
      await box.erase();

      // Pindah kembali ke halaman Login
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      AppSnackbar.show(title: "Error Logout", message: e.toString());
    }
  }

  @override
  void onClose() {
    // NOTE:
    // TextEditingController disposal is handled by GetX widgets lifecycle.
    // Disposing here can cause: "A TextEditingController was used after being disposed"
    // when input focus/gestures complete after controller is closed.
    super.onClose();
  }
}
