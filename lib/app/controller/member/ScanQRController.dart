import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../data/models/memberModel.dart'; 

class ScanQRController extends GetxController {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  
  late String idClass;
  
  var isProcessing = false.obs;

  MemberModel get member => Get.find<MemberModel>();

  @override
  void onInit() {
    super.onInit();
    idClass = Get.arguments.toString(); 
  }

  void scanQRCode(BarcodeCapture capture) {
    if (isProcessing.value) return; 

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        
        isProcessing.value = true;
        
        String rawJson = barcode.rawValue!;
        String scannedIdClass = getClassByQR(rawJson);
        bool isValid = isClassExists(scannedIdClass);

        if (isValid) {
          try {
             saveAttendance(member.uid, idClass); 
          } catch (e) {
             showResultDialog(
               title: "Error", 
               message: "Gagal membaca data user: $e", 
               isSuccess: false
             );
          }
        } else {
           showResultDialog(
             title: "Gagal", 
             message: "QR Code salah! Ini bukan kelas yang dituju.", 
             isSuccess: false
           );
        }
        break; 
      }
    }
  }

  String getClassByQR(String rawJson) {
    try {
      Map<String, dynamic> data = jsonDecode(rawJson);
      return data['idClass'] ?? "";
    } catch (e) {
      return "";
    }
  }

  bool isClassExists(String scannedId) {
    return scannedId == idClass;
  }

  void saveAttendance(String userId, String classId) async {
    try {
      await _db.child("classes").child(classId).child("checkedIn").child(userId).set(
        DateTime.now().toIso8601String()
      );

      showResultDialog(
        title: "Berhasil",
        message: "Check-In kehadiran berhasil dicatat!",
        isSuccess: true,
      );

    } catch (e) {
      showResultDialog(
        title: "Error",
        message: "Gagal menyimpan ke database: $e",
        isSuccess: false,
      );
    }
  }

  void showResultDialog({required String title, required String message, required bool isSuccess}) {
    Get.defaultDialog(
      title: title,
      titleStyle: TextStyle(
        color: isSuccess ? Colors.green : Colors.red, 
        fontWeight: FontWeight.bold
      ),
      middleText: message,
      barrierDismissible: false, // 🔒 User GABISA klik luar buat nutup (Wajib klik tombol)
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSuccess ? Colors.green : Colors.red,
        ),
        onPressed: () {
          if (isSuccess) {
            Get.offAllNamed('/userMenu'); 
          } else {
            Get.back(); 
            Future.delayed(const Duration(milliseconds: 500), () {
              isProcessing.value = false; 
            });
          }
        },
        child: Text(
          isSuccess ? "OK, Mantap" : "Scan Ulang",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}