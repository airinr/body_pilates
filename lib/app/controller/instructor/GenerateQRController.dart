import 'dart:convert';
import 'package:get/get.dart';

class GenerateQRController extends GetxController {
  late final dynamic classData;

  final qrData = ''.obs;

  @override
  void onInit() {
    super.onInit();
    classData = Get.arguments; // data kelas dari InstructorMenu

    generateQR();
  }

  void generateQR() {
    final payload = {
      "idClass": classData.idClass,
      "title": classData.title,
      "date": classData.date,
      "time": classData.time,
    };

    qrData.value = jsonEncode(payload);
  }
}
