import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
          temp.add(
            ClassModel.fromMap(
              key.toString(),
              Map<String, dynamic>.from(value),
            ),
          );
        });
      }

      allClasses.assignAll(temp);
      isLoading.value = false;
    });
  }

  /// ⬇️ HANYA NAVIGASI
  void onClassClicked(ClassModel kelas) {
    Get.toNamed('/class-detail', arguments: kelas);
  }

  void logoutClicked() async {
    _classSubscription?.cancel();
    await member.Logout();
    Get.deleteAll();
    Get.offAllNamed('/login');
  }

  void notificationClicked() {
    Get.toNamed('/notification');
  }

  @override
  void onClose() {
    _classSubscription?.cancel();
    super.onClose();
  }
}
