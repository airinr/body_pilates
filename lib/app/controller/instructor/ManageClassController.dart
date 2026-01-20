import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../data/models/classModel.dart';

class ManageClassController extends GetxController {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('classes');

  // ===============================
  // DATA KELAS
  // ===============================
  late ClassModel data;

  // ===============================
  // TEXT CONTROLLERS
  // ===============================
  late TextEditingController titleController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController priceController;

  // ===============================
  // PARTICIPANTS (🔥 TAMBAHAN)
  // ===============================
  final RxMap<String, dynamic> participants = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();

    // Ambil data kelas dari arguments
    if (Get.arguments != null) {
      data = Get.arguments as ClassModel;

      // Prefill form
      titleController = TextEditingController(text: data.title);
      dateController = TextEditingController(text: data.date);
      timeController = TextEditingController(text: data.time);
      priceController = TextEditingController(text: data.price.toString());

      // 🔥 LOAD PARTICIPANTS
      loadParticipants();
    }
  }

  // ===============================
  // LOAD PARTICIPANTS REALTIME
  // ===============================
  void loadParticipants() {
    _db.child(data.idClass).child('participants').onValue.listen((event) {
      final value = event.snapshot.value;

      if (value is Map) {
        participants.assignAll(Map<String, dynamic>.from(value));
      } else {
        participants.clear();
      }
    });
  }

  // ===============================
  // FILTER PARTICIPANTS
  // ===============================
  Map<String, dynamic> get paidParticipants {
    return Map.fromEntries(
      participants.entries.where((e) => e.value['paymentStatus'] == 'Paid'),
    );
  }

  Map<String, dynamic> get unpaidParticipants {
    return Map.fromEntries(
      participants.entries.where((e) => e.value['paymentStatus'] != 'Paid'),
    );
  }

  // ===============================
  // SUBMIT EDIT KELAS
  // ===============================
  void submitEdit() async {
    if (!validateInput()) return;

    try {
      await _db.child(data.idClass).update({
        'title': titleController.text,
        'date': dateController.text,
        'time': timeController.text,
        'price': int.parse(priceController.text),
      });

      Get.back();
      Get.snackbar(
        'Sukses',
        'Data kelas berhasil diupdate',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal update kelas');
    }
  }

  // ===============================
  // DELETE KELAS
  // ===============================
  void confirmDelete() async {
    try {
      await _db.child(data.idClass).remove();

      Get.back();
      Get.snackbar(
        'Sukses',
        'Kelas berhasil dihapus',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus kelas');
    }
  }

  // ===============================
  // VALIDASI INPUT
  // ===============================
  bool validateInput() {
    if (titleController.text.isEmpty ||
        dateController.text.isEmpty ||
        timeController.text.isEmpty ||
        priceController.text.isEmpty) {
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
