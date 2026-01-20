import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

// Import Model
import '../../data/models/classModel.dart';
import '../../data/models/memberModel.dart';

class UserMenuController extends GetxController {
  // 🔹 DB Kelas
  final DatabaseReference _db = FirebaseDatabase.instance.ref('classes');

  // 🔹 Data Member Login
  final MemberModel member = Get.find<MemberModel>();

  // 🔹 Semua kelas
  final RxList<ClassModel> allClasses = <ClassModel>[].obs;
  final RxBool isLoading = false.obs;

  StreamSubscription<DatabaseEvent>? _classSubscription;

  @override
  void onInit() {
    super.onInit();
    loadClassList();
  }

  // ===============================
  // PEMISAHAN KELAS
  // ===============================

  List<ClassModel> get enrolledClasses {
    return allClasses.where((item) {
      return member.isEnrolled(item.idClass);
    }).toList();
  }

  List<ClassModel> get availableClasses {
    return allClasses.where((item) {
      return !member.isEnrolled(item.idClass);
    }).toList();
  }

  // ===============================
  // LOAD DATA KELAS
  // ===============================

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

        allClasses.assignAll(temp);
        isLoading.value = false;
      },
      onError: (error) {
        isLoading.value = false;
        Get.snackbar('Error', 'Gagal mengambil data kelas');
      },
    );
  }

  // ===============================
  // JOIN / AMBIL KELAS
  // PARTICIPANT MASUK KE CLASS
  // ===============================

  Future<void> joinClass(ClassModel classData) async {
    try {
      final String memberId = member.uid;

      final DatabaseReference participantRef = _db
          .child(classData.idClass)
          .child('participants')
          .child(memberId);

      // 🔎 Cek apakah sudah join
      final snapshot = await participantRef.get();
      if (snapshot.exists) {
        Get.snackbar(
          "Info",
          "Anda sudah mengambil kelas ini",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // 🔥 Simpan participant DI DALAM CLASS
      await participantRef.set({
        'memberId': memberId,
        'joinedAt': DateTime.now().toIso8601String(),
        'paymentStatus': 'unpaid',
      });

      // 🔄 Update data member di memori
      member.addEnrolledClass(classData.idClass);

      // 🔄 Refresh UI
      allClasses.refresh();

      Get.snackbar(
        "Berhasil",
        "Anda berhasil mengambil kelas ${classData.title}",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal mengambil kelas",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> markAsPaid(ClassModel classData) async {
    try {
      await FirebaseDatabase.instance
          .ref('classes')
          .child(classData.idClass)
          .child('participants')
          .child(member.uid)
          .update({'paymentStatus': 'Paid'});

      // refresh UI
      allClasses.refresh();

      Get.snackbar(
        "Pembayaran",
        "Status pembayaran berhasil diperbarui",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar("Error", "Gagal update status pembayaran");
    }
  }

  // ===============================
  // DETAIL KELAS
  // ===============================

  void onClassClicked(String idClass) {
    // Get.toNamed('/classDetail', arguments: idClass);
  }

  // ===============================
  // LOGOUT
  // ===============================

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
          await member.Logout();

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
