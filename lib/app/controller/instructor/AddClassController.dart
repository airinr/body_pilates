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
    // 1. Bikin ref (Logic lama lo)
    final newClassRef = _db.push();

    if (!validateInput()) return;

    // 2. TAMPILKAN LOADING (Pengganti isLoading.value)
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // 3. Simpan Data (Masih pakai logic lama lo)
      await newClassRef.set({
        'idClass': newClassRef
            .key, // <--- HATI-HATI DI SINI (Baca penjelasan di bawah)
        'title': titleC.text,
        'date': dateC.text,
        'time': timeC.text,
        'price': int.parse(priceC.text.replaceAll('.', '')),
      });

      // 4. Tutup Loading dulu
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // 5. Tutup Halaman Form
      Get.back();
      Get.snackbar('Sukses', 'Kelas berhasil ditambahkan');
    } catch (e) {
      // Kalau error, tutup loading dulu
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.snackbar('Error', 'Gagal menambahkan kelas');
    }
    // Gak perlu finally isLoading = false karena sudah dihandle dialog
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
