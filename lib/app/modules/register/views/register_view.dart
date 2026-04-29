import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../data/theme/app_colors.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailC = TextEditingController();
    final passC = TextEditingController();
    final confirmC = TextEditingController();

    final isHiddenPass = true.obs;
    final isHiddenConfirm = true.obs;

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
                "DAFTAR",
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
                    obscureText: isHiddenPass.value,
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
                          isHiddenPass.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          isHiddenPass.value = !isHiddenPass.value;
                        },
                      ),
                    ),
                  )),

              const SizedBox(height: 15),

              /// 🔷 KONFIRMASI PASSWORD
              Obx(() => TextField(
                    controller: confirmC,
                    obscureText: isHiddenConfirm.value,
                    decoration: InputDecoration(
                      hintText: "Konfirmasi Kata Sandi",
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
                          isHiddenConfirm.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          isHiddenConfirm.value = !isHiddenConfirm.value;
                        },
                      ),
                    ),
                  )),

              const SizedBox(height: 25),

              /// 🔷 BUTTON DAFTAR
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
                    // setelah daftar → ke login
                    Get.offAllNamed(Routes.LOGIN);
                  },
                  child: const Text(
                    "Daftar",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// 🔷 GOOGLE SIGN UP
              Column(
                children: [
                  Text(
                    "atau daftar dengan",
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

              /// 🔷 KE LOGIN
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Sudah punya akun? "),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
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
}