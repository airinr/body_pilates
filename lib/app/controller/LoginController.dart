import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../routes/app_routes.dart';

import '../data/models/memberModel.dart';
import '../data/models/instructorModel.dart'; // Jangan lupa import ini!

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

  void goToRegister() {
    Get.toNamed(Routes.register);
  }

  Future<void> auth() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Email dan password tidak boleh kosong",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      isLoading.value = false;

      if (!userDoc.exists) {
        Get.snackbar("Error", "Data user tidak ditemukan di database");
        return;
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final String uid = userCredential.user!.uid;
      final String role = userData['role'] ?? '';

      dynamic createdAtRaw = userData['createdAt'];
      DateTime validCreatedAt = DateTime.now(); 
      if (createdAtRaw is Timestamp) {
        validCreatedAt = createdAtRaw.toDate();
      } else if (createdAtRaw is String) {
        validCreatedAt = DateTime.tryParse(createdAtRaw) ?? DateTime.now();
      }

      userData['createdAt'] = validCreatedAt;

      if (role == 'instructor') {
        final instructor = InstructorModel.fromFirestore(userData, uid);

        Get.put<InstructorModel>(instructor, permanent: true);

        Get.snackbar("Success", "Welcome Coach ${userData['name']}");
        Get.offAllNamed(Routes.instructorMenu);

      } else if (role == 'member') {
        final member = MemberModel.fromFirestore(userData, uid);

        Get.put<MemberModel>(member, permanent: true);

        Get.snackbar("Success", "Welcome Member ${userData['name']}");
        Get.offAllNamed(Routes.userMenu);

      } else {
        Get.snackbar("Error", "Role user tidak valid: $role");
        await _auth.signOut();
      }

    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      String message = "Login gagal";
      if (e.code == 'user-not-found') {
        message = "Email tidak terdaftar";
      } else if (e.code == 'wrong-password') {
        message = "Password salah";
      } else if (e.code == 'invalid-email') {
        message = "Format email salah";
      } else if (e.code == 'invalid-credential') {
        message = "Email atau password salah";
      }
      Get.snackbar("Login Gagal", message, backgroundColor: Colors.redAccent, colorText: Colors.white);
      
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Terjadi kesalahan: $e");
      print("Login Error: $e");
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}