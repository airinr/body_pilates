import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void togglePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> signUp() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.isEmpty ||
        usernameController.text.isEmpty) {
      Get.snackbar("Error", "Semua field harus diisi");
      return;
    }

    try {
      isLoading.value = true;

      // 1️⃣ Register ke Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      // 2️⃣ Simpan data user ke Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': nameController.text,
        'username': usernameController.text,
        'email': emailController.text,
        'createdAt': Timestamp.now(),
      });

      isLoading.value = false;

      // 3️⃣ Popup sukses
      Get.defaultDialog(
        title: "Berhasil 🎉",
        middleText: "Akun berhasil dibuat. Silakan login.",
        textConfirm: "OK",
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back(); // tutup dialog
          Get.back(); // kembali ke Login page
        },
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Register Gagal", e.toString());
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
