import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../data/models/classModel.dart';
import '../../data/models/memberModel.dart';

class UserMenuController extends GetxController {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('classes');

  MemberModel get member => Get.find<MemberModel>();

  final RxList<ClassModel> allClasses = <ClassModel>[].obs;
  final RxBool isLoading = false.obs;

  StreamSubscription<DatabaseEvent>? _classSubscription;

  @override
  void onInit() {
    super.onInit();
    loadClassList();
  }

  List<ClassModel> get enrolledClasses => member.enrolledClassIds.isEmpty
      ? []
      : allClasses.where((c) => member.isEnrolled(c.idClass)).toList();

  List<ClassModel> get availableClasses =>
      allClasses.where((c) => !member.isEnrolled(c.idClass)).toList();

  void loadClassList() {
    isLoading.value = true;

    _classSubscription = _db.onValue.listen((event) {
      final data = event.snapshot.value;
      final List<ClassModel> temp = [];

      if (data is Map) {
        data.forEach((key, value) {
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

  void onClassClicked(ClassModel kelas) {
    bool isEnrolled = member.isEnrolled(kelas.idClass);

    if (isEnrolled) {
      Get.toNamed(
        '/class-after',
        arguments: {'idClass': kelas.idClass},
      );
    } else {
      Get.toNamed(
        '/class-before',
        arguments: {
          'idClass': kelas.idClass,
          'idUser': member.uid, 
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