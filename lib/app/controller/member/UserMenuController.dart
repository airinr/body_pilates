import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../data/models/classModel.dart';
import '../../data/models/memberModel.dart';

class UserMenuController extends GetxController {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('classes');

  // Akses MemberModel untuk cek status enrolled & ambil UID
  MemberModel get member => Get.find<MemberModel>();

  final RxList<ClassModel> allClasses = <ClassModel>[].obs;
  final RxBool isLoading = false.obs;

  StreamSubscription<DatabaseEvent>? _classSubscription;

  @override
  void onInit() {
    super.onInit();
    loadClassList();
  }

  // Filter Kelas yang SUDAH diambil
  List<ClassModel> get enrolledClasses => member.enrolledClassIds.isEmpty
      ? []
      : allClasses.where((c) => member.isEnrolled(c.idClass)).toList();

  // Filter Kelas yang BELUM diambil
  List<ClassModel> get availableClasses =>
      allClasses.where((c) => !member.isEnrolled(c.idClass)).toList();

  void loadClassList() {
    isLoading.value = true;

    // Mendengarkan perubahan data realtime
    _classSubscription = _db.onValue.listen((event) {
      final data = event.snapshot.value;
      final List<ClassModel> temp = [];

      if (data is Map) {
        data.forEach((key, value) {
          // Parsing data dengan aman
          if (value is Map) {
             temp.add(
              ClassModel.fromMap(
                key.toString(),
                Map<dynamic, dynamic>.from(value), 
              ),
            );
          }
        });
      }

      allClasses.assignAll(temp);
      isLoading.value = false;
    }, onError: (error) {
       isLoading.value = false;
       print("Error loading classes: $error");
    });
  }

  // ==========================================
  // METHOD SESUAI DIAGRAM & LOGIC REQUEST
  // ==========================================
  void onClassClicked(ClassModel kelas) {
    // 1. Cek apakah user sudah terdaftar di kelas ini?
    bool isEnrolled = member.isEnrolled(kelas.idClass);

    if (isEnrolled) {
      // 2a. Jika SUDAH terdaftar -> Ke Class After
      // Argumen: idClass saja
      Get.toNamed(
        '/class-after',
        arguments: {'idClass': kelas.idClass},
      );
    } else {
      // 2b. Jika BELUM terdaftar -> Ke Class Before
      // Argumen: idClass & idUser (Sesuai kode awal)
      Get.toNamed(
        '/class-before',
        arguments: {
          'idClass': kelas.idClass,
          'idUser': member.uid, // Ambil ID user dari MemberModel
        },
      );
    }
  }

  void notificationClicked() {
    Get.toNamed('/notification');
  }

  void logoutClicked() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Apakah Anda yakin ingin keluar?",
      textConfirm: "Ya, Keluar",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        try {
          _classSubscription?.cancel();
          await member.Logout();
          Get.deleteAll(force: true);
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