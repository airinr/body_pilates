import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../data/models/classModel.dart';

class ManageClassController extends GetxController {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('classes');

  late ClassModel data;

  late TextEditingController titleController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController priceController;

  final RxMap<String, dynamic> participants = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      data = Get.arguments as ClassModel;

      titleController = TextEditingController(text: data.title);
      dateController = TextEditingController(text: data.date);
      timeController = TextEditingController(text: data.time);
      priceController = TextEditingController(text: data.price.toString());

      loadParticipants();
    }
  }

  void loadParticipants() {
    _db.child(data.idClass).child('participants').onValue.listen((event) {
      final value = event.snapshot.value;

      if (value is Map) {
        participants.assignAll(Map<String, dynamic>.from(value));
      } else {
        participants.clear();
      }
    });
  }

  Map<String, dynamic> get paidParticipants {
    return Map.fromEntries(
      participants.entries.where((e) => e.value['paymentStatus'] == 'Paid'),
    );
  }

  Map<String, dynamic> get unpaidParticipants {
    return Map.fromEntries(
      participants.entries.where((e) => e.value['paymentStatus'] != 'Paid'),
    );
  }

  void submitEdit() async {
    if (!validateInput()) return;

    try {
      await _db.child(data.idClass).update({
        'title': titleController.text,
        'date': dateController.text,
        'time': timeController.text,
        'price': int.parse(priceController.text),
      });

      Get.back();
      Get.snackbar(
        'Sukses',
        'Data kelas berhasil diupdate',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal update kelas');
    }
  }

  void confirmDelete() async {
    Get.back();

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      String classId = data.idClass;
      final notifRef = FirebaseDatabase.instance.ref('notifications');

      final notifSnapshot = await notifRef.get();

      if (notifSnapshot.exists && notifSnapshot.value is Map) {
        Map<dynamic, dynamic> notifs =
            notifSnapshot.value as Map<dynamic, dynamic>;

        List<Future> deleteTasks = [];

        notifs.forEach((key, value) {
          if (value is Map && value['classId'] == classId) {
            deleteTasks.add(notifRef.child(key.toString()).remove());
          }
        });

        await Future.wait(deleteTasks);
      }

      await _db.child(classId).remove();

    } catch (e) {
      print("Error saat menghapus: $e");
    } finally {
      if (Get.isDialogOpen ?? false) {
        Get.back(); 
      }

      Get.back(); 

      Get.snackbar('Sukses', 'Kelas berhasil dihapus');
    }
  }

  bool validateInput() {
    if (titleController.text.isEmpty ||
        dateController.text.isEmpty ||
        timeController.text.isEmpty ||
        priceController.text.isEmpty) {
      Get.snackbar('Error', 'Semua field harus diisi');
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    titleController.dispose();
    dateController.dispose();
    timeController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
