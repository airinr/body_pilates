import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../data/models/transactionModel.dart';
import '../../controller/member/ClassBeforeController.dart'; 

class PaymentController extends GetxController {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  
  // Data dari arguments
  late String idClass;
  late String className;
  late int price;
  late String idUser;

  var isLoading = false.obs;
  var selectedPaymentMethod = 'Transfer Bank (BCA)'.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    idClass = args['idClass'];
    className = args['className'];
    price = args['price'];
    idUser = args['idUser'];
  }

  // Sesuai Diagram: createTransaction
  Future<void> createTransaction() async {
    isLoading.value = true;
    
    // Simulasi loading transaksi...
    await Future.delayed(const Duration(seconds: 2));

    try {
      String newTransId = _db.child('transactions').push().key!;
      
      // 1. Buat Model Transaksi
      TransactionModel newTransaction = TransactionModel(
        transactionId: newTransId,
        orderId: "ORDER-${DateTime.now().millisecondsSinceEpoch}",
        amount: price,
        paymentMethod: selectedPaymentMethod.value,
        status: TransactionStatus.SUCCESS, 
        timestamp: DateTime.now().toIso8601String(),
      );

      // 2. Simpan Transaksi ke Database
      await _db.child('transactions').child(newTransId).set(newTransaction.toMap());

      // 3. Panggil Handle Success
      await handleSuccess(idClass, idUser);

    } catch (e) {
      Get.snackbar("Error", "Transaksi Gagal: $e", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Sesuai Diagram: handleSuccess
  Future<void> handleSuccess(String idClass, String idUser) async {
    try {
      // 🔥 CROSS-CONTROLLER CALL 🔥
      // Kita cari ClassBeforeController yang masih hidup di memori
      if (Get.isRegistered<ClassBeforeController>()) {
        final classController = Get.find<ClassBeforeController>();
        
        // Panggil fungsi addClassMember milik controller sebelah
        await classController.addClassMember(idClass, idUser);
        
        // Tampilkan Sukses & Navigasi
        Get.snackbar(
          "Pembayaran Berhasil", 
          "Selamat, kamu telah terdaftar di kelas $className!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Pindah ke halaman Class After (Success Page)
        Get.offNamed('/class-after', arguments: {'idClass': idClass});
        
      } else {
        throw Exception("Controller ClassBefore tidak ditemukan");
      }
    } catch (e) {
      print("Error Handling Success: $e");
      Get.snackbar("Error", "Gagal mendaftarkan peserta: $e");
    }
  }
}