import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/LoginController.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';

class LoginPage extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPink,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.softPink.withOpacity(0.4),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPink,
                  ),
                ),
                const SizedBox(height: 24),

                AppTextField(
                  label: "Email",
                  icon: Icons.person_outline,
                  controller: controller.emailController,
                ),

                const SizedBox(height: 16),

                Obx(
                  () => AppTextField(
                    label: "Password",
                    icon: Icons.lock_outline,
                    obscureText: controller.isPasswordHidden.value,
                    controller: controller.passwordController,
                  ),
                ),

                const SizedBox(height: 24),

                Obx(
                  () => AppButton(
                    text: "Login",
                    isLoading: controller.isLoading.value,
                    onPressed: controller.auth,
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: controller.goToRegister,
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      color: AppColors.primaryPink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
