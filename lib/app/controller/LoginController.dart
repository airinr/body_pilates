import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Controller input
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // State
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  // Toggle show/hide password
  void togglePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Login logic
  void login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Username dan password tidak boleh kosong",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    // Simulasi API call
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    // Dummy login
    if (username == "admin" && password == "123456") {
      Get.snackbar(
        "Success",
        "Login berhasil",
        snackPosition: SnackPosition.BOTTOM,
      );

      // Get.offAllNamed('/home');
    } else {
      Get.snackbar(
        "Login Gagal",
        "Username atau password salah",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
