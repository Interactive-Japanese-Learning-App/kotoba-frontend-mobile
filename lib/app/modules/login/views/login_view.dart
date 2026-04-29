import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../data/theme/app_colors.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailC = TextEditingController();
    final passC = TextEditingController();
    final isHidden = true.obs;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [

              const SizedBox(height: 40),

              /// 🔷 LOGO
              Image.asset(
                "assets/images/kotoba-logo.png",
                height: 120,
              ),

              const SizedBox(height: 20),

              /// 🔷 TITLE
              Text(
                "MASUK",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 30),

              /// 🔷 EMAIL
              TextField(
                controller: emailC,
                decoration: InputDecoration(
                  hintText: "Email",
                  filled: true,
                  fillColor: AppColors.neutral,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// 🔷 PASSWORD
              Obx(() => TextField(
                    controller: passC,
                    obscureText: isHidden.value,
                    decoration: InputDecoration(
                      hintText: "Kata Sandi",
                      filled: true,
                      fillColor: AppColors.neutral,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          isHidden.value = !isHidden.value;
                        },
                      ),
                    ),
                  )),

              const SizedBox(height: 25),

              /// 🔷 BUTTON MASUK
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Get.toNamed(Routes.HOME);
                  },
                  child: const Text(
                    "Masuk",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// 🔷 GOOGLE LOGIN
              Column(
                children: [
                  Text(
                    "atau masuk dengan",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      // TODO: Google Sign In
                    },
                    child: SizedBox(
                      height: 40,
                      child: Image.asset(
                        "assets/images/logo-google.png",
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// 🔷 DAFTAR
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun? "),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.REGISTER);
                    },
                    child: Text(
                      "Daftar",
                      style: TextStyle(
                        color: AppColors.danger, // merah kamu
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
}