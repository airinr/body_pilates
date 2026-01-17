import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/RegisterController.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';

class RegisterPage extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPink,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPink,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primaryPink),
        title: Text("Register", style: TextStyle(color: AppColors.primaryPink)),
      ),
      body: Center(
        child: SingleChildScrollView(
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
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryPink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please fill the form below",
                    style: TextStyle(color: AppColors.textGrey),
                  ),

                  const SizedBox(height: 24),

                  // Full Name
                  AppTextField(
                    label: "Full Name",
                    icon: Icons.person_outline,
                    controller: controller.nameController,
                  ),

                  const SizedBox(height: 16),

                  // Username
                  AppTextField(
                    label: "Username",
                    icon: Icons.account_circle_outlined,
                    controller: controller.usernameController,
                  ),

                  const SizedBox(height: 16),

                  // Email
                  AppTextField(
                    label: "Email",
                    icon: Icons.email_outlined,
                    controller: controller.emailController,
                  ),

                  const SizedBox(height: 16),

                  // Password
                  Obx(
                    () => AppTextField(
                      label: "Password",
                      icon: Icons.lock_outline,
                      controller: controller.passwordController,
                      obscureText: controller.isPasswordHidden.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: controller.togglePassword,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Register Button
                  Obx(
                    () => AppButton(
                      text: "Register",
                      isLoading: controller.isLoading.value,
                      onPressed: controller.signUp,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: AppColors.primaryPink,
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
        ),
      ),
    );
  }
}
