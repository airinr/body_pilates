import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../routes/app_routes.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void togglePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // 🔹 PINDAH KE REGISTER
  void goToRegister() {
    Get.toNamed(Routes.register);
  }

  // 🔹 LOGIN FIREBASE
  Future<void> auth() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Email dan password tidak boleh kosong",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      // 1️⃣ Login Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2️⃣ Ambil data user dari Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      final role = userDoc['role'];

      isLoading.value = false;

      if (!userDoc.exists) {
        Get.snackbar("Error", "Data user tidak ditemukan");
        return;
      }

      final userData = userDoc.data() as Map<String, dynamic>;

      // 3️⃣ Login sukses
      Get.snackbar(
        "Success",
        "Selamat datang ${userData['name']}",
        snackPosition: SnackPosition.BOTTOM,
      );

      // 4️⃣ Navigasi ke Home
      if (role == 'instructor') {
        Get.offAllNamed(Routes.instructorMenu);
      } else {
        Get.offAllNamed(Routes.register);
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;

      String message = "Login gagal";
      if (e.code == 'user-not-found') {
        message = "Email tidak terdaftar";
      } else if (e.code == 'wrong-password') {
        message = "Password salah";
      }

      Get.snackbar("Login Gagal", message);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
