import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class AddClassController extends GetxController {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('classes');

  final titleC = TextEditingController();
  final dateC = TextEditingController();
  final timeC = TextEditingController();
  final priceC = TextEditingController();

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // default tanggal hari ini
    dateC.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  bool validateInput() {
    if (titleC.text.isEmpty ||
        dateC.text.isEmpty ||
        timeC.text.isEmpty ||
        priceC.text.isEmpty) {
      Get.snackbar('Validasi', 'Semua field wajib diisi');
      return false;
    }

    if (int.tryParse(priceC.text.replaceAll('.', '')) == null) {
      Get.snackbar('Validasi', 'Harga harus berupa angka');
      return false;
    }

    return true;
  }

  Future<void> saveData() async {
    if (!validateInput()) return;

    isLoading.value = true;

    try {
      await _db.push().set({
        'title': titleC.text,
        'date': dateC.text,
        'time': timeC.text,
        'price': int.parse(priceC.text.replaceAll('.', '')),
      });

      Get.back();
      Get.snackbar('Sukses', 'Kelas berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan kelas');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleC.dispose();
    dateC.dispose();
    timeC.dispose();
    priceC.dispose();
    super.onClose();
  }
}
