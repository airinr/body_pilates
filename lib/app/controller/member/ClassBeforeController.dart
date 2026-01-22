import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/classModel.dart';
import '../../data/models/memberModel.dart';

class ClassBeforeController extends GetxController {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('classes');

  MemberModel get member => Get.find<MemberModel>();

  late String idClass;
  late String userId;

  final Rx<ClassModel?> classDetail = Rx<ClassModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    idClass = Get.arguments['idClass'];
    userId = Get.arguments['idUser'];

    loadClassDetailBefore(idClass);
  }

  // =============================
  // loadClassDetailBefore(idClass)
  // =============================
  void loadClassDetailBefore(String idClass) async {
    isLoading.value = true;

    try {
      final snapshot = await _db.child(idClass).get();
      if (snapshot.exists) {
        classDetail.value = ClassModel.fromMap(
          idClass,
          Map<String, dynamic>.from(snapshot.value as Map),
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat detail kelas");
    }

    isLoading.value = false;
  }

  // =============================
  // payClass(idUser, idClass)
  // =============================
  Future<void> payClass(String idUser, String idClass) async {
    /// ⬇️ STEP 1: tampilkan QR dummy
    _showQRPaymentDialog(idUser, idClass);
  }

  // =============================
  // QR DUMMY PAYMENT POPUP
  // =============================
  void _showQRPaymentDialog(String idUser, String idClass) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          "Pembayaran Kelas",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.qr_code, size: 160),
            const SizedBox(height: 12),
            Text(
              "Nama: ${member.fullName}",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text("Total: Rp ${classDetail.value?.price ?? 0}"),
            const SizedBox(height: 12),
            const Text(
              "Silakan scan QR untuk melakukan pembayaran",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              Get.back(); // tutup dialog
              await _processPayment(idUser, idClass);
            },
            child: const Text("Saya Sudah Bayar"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // =============================
  // PROSES PEMBAYARAN (REAL LOGIC)
  // =============================
  Future<void> _processPayment(String idUser, String idClass) async {
    try {
      await addClassMember(idClass, idUser);

      Get.snackbar(
        "Berhasil",
        "Pembayaran berhasil, Anda tergabung ke kelas",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offNamed('/class-after', arguments: {'idClass': idClass});
    } catch (e) {
      print("PAYMENT ERROR: $e");
      Get.snackbar("Error", e.toString());
    }
  }

  // =============================
  // addClassMember(idClass, idUser)
  // =============================
  Future<void> addClassMember(String idClass, String idUser) async {
    if (!Get.isRegistered<MemberModel>()) {
      Get.snackbar(
        "Error",
        "Session user tidak ditemukan, silakan login ulang",
      );
      return;
    }

    await _db.child(idClass).child('participants').child(idUser).set({
      'memberId': idUser,
      'memberName': member.fullName,
      'joinedAt': DateTime.now().toIso8601String(),
      'paymentStatus': 'Paid',
    });

    await FirebaseFirestore.instance.collection('users').doc(idUser).set({
      'enrolledClassIds': FieldValue.arrayUnion([idClass]),
    }, SetOptions(merge: true));

    member.enrollClass(idClass);
  }
}
