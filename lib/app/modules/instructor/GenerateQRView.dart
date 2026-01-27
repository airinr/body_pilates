import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../controller/instructor/GenerateQRController.dart';
import '../../core/theme/app_colors.dart';

class GenerateQRView extends GetView<GenerateQRController> {
  const GenerateQRView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors
          .primaryPink, // Background utama Biru agar kontras dengan kartu putih
      appBar: AppBar(
        title: const Text(
          "QR Check-in",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryPink,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close_rounded,
          ), // Icon close karena ini biasanya modal/fullscreen
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Obx(() {
            if (controller.qrData.isEmpty) {
              return const CircularProgressIndicator(color: Colors.white);
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // KARTU QR CODE
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 40,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // 1. INFO KELAS (Header)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundPink,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.qr_code_2_rounded,
                          size: 32,
                          color: AppColors.primaryPink,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.classData.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.darkPink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${controller.classData.date} • ${controller.classData.time}",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 2. QR CODE IMAGE
                      // Kita bungkus QR dengan border tipis agar terlihat rapi
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: QrImageView(
                          data: controller.qrData.value,
                          version: QrVersions.auto,
                          size: 220,
                          backgroundColor: Colors.white,
                          // Optional: Menambahkan logo kecil di tengah QR jika diinginkan
                          // embeddedImage: const AssetImage('assets/logo.png'),
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: Colors.black,
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 3. INSTRUKSI
                      Text(
                        "Tunjukkan QR ini kepada Member",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Scan menggunakan menu kamera di aplikasi member",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // TIP DI LUAR KARTU
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.light_mode_outlined,
                      color: Colors.white70,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Pastikan kecerahan layar hp anda cukup",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
