import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../data/models/classModel.dart';
import '../../data/models/instructorModel.dart';

class InstructorMenuController extends GetxController {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('classes');

  final RxList<ClassModel> classList = <ClassModel>[].obs;
  final RxBool isLoading = false.obs;

  final InstructorModel instructor = Get.find<InstructorModel>();

  StreamSubscription<DatabaseEvent>? _classSubscription;

  @override
  void onInit() {
    super.onInit();
    loadAllClasses();
  }

  void loadAllClasses() {
    isLoading.value = true;

    _classSubscription?.cancel();

    _classSubscription = _db.onValue.listen(
      (event) {
        final data = event.snapshot.value;
        final List<ClassModel> temp = [];

        if (data is Map) {
          data.forEach((key, value) {
            if (value is Map) {
              temp.add(
                ClassModel.fromMap(
                  key.toString(),
                  Map<String, dynamic>.from(value),
                ),
              );
            }
          });
        }

        classList.assignAll(temp);
        isLoading.value = false;
      },
      onError: (error) {
        isLoading.value = false;
        Get.snackbar('Error', 'Gagal mengambil data kelas');
      },
    );
  }

  // Method baru untuk proses logout
  void logout() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Apakah Anda yakin ingin keluar?",
      textConfirm: "Ya, Keluar",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        try {
          // 2. Panggil method Logout() punya parent (UserModel) lewat object child (Instructor)
          // Ini sah banget di OOP
          await instructor.Logout();

          // 3. PENTING: Hapus data instructor dari memori GetX
          // Karena pas login kita set 'permanent: true', kita wajib hapus manual pas logout
          // Biar kalau login pakai akun lain datanya gak nyangkut.
          Get.delete<InstructorModel>(force: true);

          // 4. Balik ke halaman login
          Get.offAllNamed('/login');
        } catch (e) {
          Get.snackbar("Error", "Gagal logout: $e");
        }
      },
    );
  }

  void showBroadcastDialog(String idClass, String className) {
    // 1. Siapkan controller buat nangkep inputan
    final titleController = TextEditingController();
    final messageController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('Kirim Pesan ke "$className"'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Judul Pengumuman',
                hintText: 'Contoh: Perubahan Jam Kelas',
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: messageController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Isi Pesan',
                hintText: 'Tulis pesan lengkap di sini...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),

          ElevatedButton(
            onPressed: () {
              // 1. Validasi di sini sebelum lanjut
              if (titleController.text.trim().isEmpty ||
                  messageController.text.trim().isEmpty) {
                Get.snackbar(
                  'Peringatan',
                  'Judul dan Pesan tidak boleh kosong!',
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
                return; // Berhenti di sini, jangan lanjut ke bawah
              }

              // 2. Kalau valid, baru kirim
              sendBroadcast(
                idClass,
                titleController.text,
                messageController.text,
              );

              // 3. Tutup dialog
              Get.back();

              // 4. Munculkan snackbar sukses (Gunakan $ untuk variabel)
              Get.snackbar(
                'Sukses',
                'Pesan telah terkirim ke kelas $className', // Gunakan $ bukan {}
                backgroundColor: Colors.green, // Sebaiknya hijau untuk sukses
                colorText: Colors.white,
              );
            },
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }

  void sendBroadcast(String idClass, String title, String message) {
    FirebaseDatabase.instance
        .ref('notifications')
        .push()
        .set({
          'classId': idClass, 
          'title': title, 
          'message': message, 
          'timestamp': DateTime.now().millisecondsSinceEpoch, 
        })
        .catchError((error) {
          Get.snackbar("Error Database", "Gagal simpan: $error");
        });
  }

  void deleteClass(String idClass) async {
    try {
      await _db.child(idClass).remove();
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus kelas');
    }
  }

  @override
  void onClose() {
    _classSubscription?.cancel();
    super.onClose();
  }
}
