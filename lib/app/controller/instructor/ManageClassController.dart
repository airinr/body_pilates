import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../data/models/classModel.dart';

class ManageClassController extends GetxController {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('classes');
  
  // Data yang diterima dari halaman sebelumnya
  late ClassModel data;

  // Controller untuk TextFields
  late TextEditingController titleController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController priceController;

  @override
  void onInit() {
    super.onInit();
    // Ambil data yang dikirim via arguments
    if (Get.arguments != null) {
      data = Get.arguments as ClassModel;
      
      // Isi form dengan data yang ada (Pre-fill)
      titleController = TextEditingController(text: data.title);
      dateController = TextEditingController(text: data.date);
      timeController = TextEditingController(text: data.time);
      priceController = TextEditingController(text: data.price.toString());
    }
  }

  // Sesuai Diagram: submitEdit()
  void submitEdit() async {
    if (!validateInput()) return;

    try {
      await _db.child(data.idClass).update({
        'title': titleController.text,
        'date': dateController.text,
        'time': timeController.text,
        'price': int.parse(priceController.text),
      });
      
      Get.back(); // Kembali ke menu utama
      Get.snackbar('Sukses', 'Data kelas berhasil diupdate', 
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Gagal update kelas');
    }
  }

  // Sesuai Diagram: confirmDelete()
  void confirmDelete() async {
    try {
      await _db.child(data.idClass).remove();
      
      Get.back(); // Kembali ke menu utama
      Get.snackbar('Sukses', 'Kelas berhasil dihapus',
           backgroundColor: Colors.redAccent, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus kelas');
    }
  }

  // Sesuai Diagram: validateInput()
  bool validateInput() {
    if (titleController.text.isEmpty || priceController.text.isEmpty) {
      Get.snackbar('Error', 'Semua field harus diisi');
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    titleController.dispose();
    dateController.dispose();
    timeController.dispose();
    priceController.dispose();
    super.onClose();
  }
}