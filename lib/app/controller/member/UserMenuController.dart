import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/classModel.dart';
import '../../data/models/memberModel.dart';

class UserMenuController extends GetxController {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('classes');
  
  // Mengambil instance member yang sedang login
  MemberModel get member => Get.find<MemberModel>();

  final RxList<ClassModel> allClasses = <ClassModel>[].obs;
  final RxBool isLoading = false.obs;

  StreamSubscription<DatabaseEvent>? _classSubscription;

  @override
  void onInit() {
    super.onInit();
    loadClassList();
  }

  // ===============================
  // PEMISAHAN KELAS (FILTER)
  // ===============================

  List<ClassModel> get enrolledClasses {
    // FIX: Cek member masih ada di memori gak, biar gak crash
    if (!Get.isRegistered<MemberModel>()) return []; 
    return allClasses.where((item) => member.isEnrolled(item.idClass)).toList();
  }

  List<ClassModel> get availableClasses {
    if (!Get.isRegistered<MemberModel>()) return [];
    return allClasses.where((item) => !member.isEnrolled(item.idClass)).toList();
  }

  // ===============================
  // LOAD DATA KELAS (STREAM)
  // ===============================

  void loadClassList() {
    isLoading.value = true;

    // FIX: Perbaikan logic listener ganda jadi single listener
    _classSubscription = _db.onValue.listen(
      (event) {
        // FIX CRASH ZOMBIE:
        // Cek dulu apakah MemberModel masih ada di memori?
        // Kalau user sudah logout, kode di bawah STOP dan gak bakal akses member lagi.
        if (!Get.isRegistered<MemberModel>()) return;

        final data = event.snapshot.value;
        final List<ClassModel> temp = [];

        if (data is Map) {
          data.forEach((key, value) {
            if (value is Map) {
              temp.add(ClassModel.fromMap(
                key.toString(),
                Map<String, dynamic>.from(value),
              ));
            }
          });
        }

        allClasses.assignAll(temp);

        // LOGIKA SELF-CLEANUP (Hapus ID kelas yang sudah dihapus instruktur)
        try {
           // Pastikan member masih valid sebelum akses propertinya
           if (Get.isRegistered<MemberModel>()) {
              List<String> activeClassIds = temp.map((e) => e.idClass).toList();
              
              for (String enrolledId in member.enrolledClassIds) {
                if (!activeClassIds.contains(enrolledId)) {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(member.uid)
                      .update({
                        'enrolledClassIds': FieldValue.arrayRemove([enrolledId]),
                      });
                  print("Sampah ID dibersihkan: $enrolledId");
                }
              }
           }
        } catch (e) {
           print("Cleanup error (safe to ignore): $e");
        }

        isLoading.value = false;
      },
      onError: (error) {
        isLoading.value = false;
        // Cek dialog open biar gak numpuk snackbar
        if (!Get.isSnackbarOpen) {
           Get.snackbar('Error', 'Gagal mengambil data kelas');
        }
      },
    );
  }

  // ===============================
  // JOIN KELAS
  // ===============================

  Future<void> joinClass(ClassModel classData) async {
    try {
      final String memberId = member.uid;
      final String memberName = member.fullName;

      final DatabaseReference participantRef = FirebaseDatabase.instance
          .ref('classes')
          .child(classData.idClass)
          .child('participants')
          .child(memberId);

      final snapshot = await participantRef.get();
      if (snapshot.exists) {
        Get.snackbar("Info", "Anda sudah mengikuti kelas ini");
        return;
      }

      // 1. Simpan ke RTDB
      await participantRef.set({
        'memberId': memberId,
        'memberName': memberName,
        'joinedAt': DateTime.now().toIso8601String(),
        'paymentStatus': 'Unpaid',
      });

      // 2. Update Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(memberId)
          .update({
            'enrolledClassIds': FieldValue.arrayUnion([classData.idClass]),
          });

      // 3. Update UI Local
      member.enrollClass(classData.idClass);
      allClasses.refresh();

      Get.snackbar(
        "Berhasil",
        "Anda berhasil mengikuti kelas ${classData.title}",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar("Error", "Gagal mengikuti kelas");
    }
  }

  // ===============================
  // BAYAR / MARK PAID
  // ===============================

  Future<void> markAsPaid(ClassModel classData) async {
    try {
      await FirebaseDatabase.instance
          .ref('classes')
          .child(classData.idClass)
          .child('participants')
          .child(member.uid)
          .update({'paymentStatus': 'Paid'});

      allClasses.refresh();

      Get.snackbar("Pembayaran", "Status pembayaran diperbarui");
    } catch (e) {
      Get.snackbar("Error", "Gagal update status pembayaran");
    }
  }

  void onClassClicked(String idClass) {
    // Navigasi detail jika diperlukan
  }

  // ===============================
  // LOGOUT (FIXED)
  // ===============================

  void logoutClicked() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Apakah Anda yakin ingin keluar?",
      textConfirm: "Ya",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.pinkAccent,
      onConfirm: () async {
        // FIX: Matikan stream dulu sebelum logout agar tidak terjadi memory leak/crash
        _classSubscription?.cancel();
        
        try {
          await member.Logout(); // Proses logout firebase auth

          // Hapus semua controller dari memori
          Get.deleteAll(); 
          Get.offAllNamed('/login');
        } catch (e) {
          Get.snackbar("Error", "Gagal logout: $e");
        }
      },
    );
  }

  void notificationClicked() {
    Get.toNamed('/notification');
  }

  @override
  void onClose() {
    // FIX: Pastikan stream mati saat controller dibuang
    _classSubscription?.cancel();
    super.onClose();
  }
}