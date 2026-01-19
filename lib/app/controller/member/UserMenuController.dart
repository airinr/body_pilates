import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

// Import Model
import '../../data/models/classModel.dart';
import '../../data/models/memberModel.dart';

class UserMenuController extends GetxController {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('classes');

  // 1. Ambil data Member yang sudah login (Disimpan di LoginController)
  // Kita pakai 'late' atau langsung assign karena pasti sudah ada di memori
  final MemberModel member = Get.find<MemberModel>();

  // List semua kelas dari Firebase
  final RxList<ClassModel> allClasses = <ClassModel>[].obs;
  final RxBool isLoading = false.obs;

  StreamSubscription<DatabaseEvent>? _classSubscription;

  @override
  void onInit() {
    super.onInit();
    loadClassList(); // Sesuai diagram
  }

  // 2. LOGIC PEMISAHAN KELAS (Enrolled vs Available)
  // Ini akan otomatis ter-update kalau 'allClasses' berubah
  List<ClassModel> get enrolledClasses {
    return allClasses.where((item) {
      // Panggil method isEnrolled punya MemberModel
      return member.isEnrolled(item.idClass);
    }).toList();
  }

  List<ClassModel> get availableClasses {
    return allClasses.where((item) {
      // Kebalikannya, ambil yang belum di-enroll
      return !member.isEnrolled(item.idClass);
    }).toList();
  }

  // 3. Fetch Data dari Firebase (Sama seperti instructor tapi read-only)
  void loadClassList() {
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
        
        // Simpan ke RxList, otomatis UI yang pake Obx bakal berubah
        allClasses.assignAll(temp);
        isLoading.value = false;
      },
      onError: (error) {
        isLoading.value = false;
        Get.snackbar('Error', 'Gagal mengambil data kelas');
      },
    );
  }

  // 4. Handle Klik Kelas (Navigasi ke Detail)
  // Sesuai diagram: onClassClicked
  void onClassClicked(String idClass) {
    // Kita kirim ID Class ke halaman detail
    // Nanti di halaman detail baru ada tombol "Enroll"
    // Get.toNamed('/classDetail', arguments: idClass);
  }

  // 5. Logout Khusus Member
  // Sesuai diagram: logoutClicked
  void logoutClicked() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Ingin keluar dari akun member?",
      textConfirm: "Ya",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.pinkAccent,
      onConfirm: () async {
        try {
          // Panggil fungsi Logout dari parent (UserModel) lewat MemberModel
          await member.Logout(); 
          
          // HAPUS data member dari memori agar bersih
          Get.delete<MemberModel>(force: true); 

          Get.offAllNamed('/login');
        } catch (e) {
          Get.snackbar("Error", "Gagal logout: $e");
        }
      },
    );
  }

  @override
  void onClose() {
    _classSubscription?.cancel();
    super.onClose();
  }
}