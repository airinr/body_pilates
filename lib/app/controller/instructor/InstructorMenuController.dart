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

  // void addClass({
  //   required String title,
  //   required String date,
  //   required String time,
  //   required int price,
  // }) async {
  //   try {
  //     await _db.push().set({
  //       'title': title,
  //       'date': date,
  //       'time': time,
  //       'price': price,
  //     });
  //   } catch (e) {
  //     Get.snackbar('Error', 'Gagal menambah kelas');
  //   }
  // }

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
