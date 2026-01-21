import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../controller/instructor/GenerateQRController.dart';

class GenerateQRView extends GetView<GenerateQRController> {
  const GenerateQRView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Check-in Kelas"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Center(
        child: Obx(
          () => controller.qrData.isEmpty
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🔹 Info kelas
                    Text(
                      controller.classData.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${controller.classData.date} • ${controller.classData.time}",
                    ),

                    const SizedBox(height: 24),

                    // 🔹 QR Code
                    QrImageView(
                      data: controller.qrData.value,
                      size: 250,
                      backgroundColor: Colors.white,
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "Tunjukkan QR ini kepada member\nuntuk check-in",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
