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
    // 1. Tutup Dialog Konfirmasi dulu
    Get.back();

    // 2. TAMPILKAN LOADING (PENTING! Biar user gak bisa ngapa-ngapain & UI gak freeze)
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      String classId = data.idClass; // Pastikan data masih ada
      final notifRef = FirebaseDatabase.instance.ref('notifications');

      // --- MULAI PROSES BERAT ---

      // A. Ambil semua notifikasi
      final notifSnapshot = await notifRef.get();

      if (notifSnapshot.exists && notifSnapshot.value is Map) {
        Map<dynamic, dynamic> notifs =
            notifSnapshot.value as Map<dynamic, dynamic>;

        // B. KUMPULKAN TASK PENGHAPUSAN (JANGAN DIAWAIT SATU-SATU)
        List<Future> deleteTasks = [];

        notifs.forEach((key, value) {
          if (value is Map && value['classId'] == classId) {
            // Masukkan perintah hapus ke dalam list antrian (belum dieksekusi/ditunggu)
            deleteTasks.add(notifRef.child(key.toString()).remove());
          }
        });

        // C. EKSEKUSI SEMUA PENGHAPUSAN SEKALIGUS (PARALEL)
        // Ini jauh lebih cepat daripada looping await satu-satu
        await Future.wait(deleteTasks);
      }

      // D. HAPUS KELAS UTAMA
      await _db.child(classId).remove();

    } catch (e) {
      print("Error saat menghapus: $e");
    } finally {
      // 3. TUTUP LOADING
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Tutup loading spinner
      }

      // 4. BARU KELUAR DARI HALAMAN MANAGE CLASS
      Get.back(); // Kembali ke menu sebelumnya

      Get.snackbar('Sukses', 'Kelas berhasil dihapus');
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
