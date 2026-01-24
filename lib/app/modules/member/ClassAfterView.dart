import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/member/ClassAfterController.dart';
import '../../data/models/classModel.dart';

class ClassAfterView extends GetView<ClassAfterController> {
  const ClassAfterView({super.key});

  // Sesuai Diagram: classAfterPage() -> Ini adalah method build()
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelas Saya"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final ClassModel? kelas = controller.classDetail.value;

        if (kelas == null) {
          return const Center(child: Text("Data kelas tidak ditemukan"));
        }

        // Render Detail
        return _buildClassDetailAfter(kelas);
      }),
    );
  }

  // Sesuai Diagram: showClassDetailBefore(idClass: String)
  // (Method ini menampilkan detail UI untuk kelas yang sudah dibayar)
  Widget _buildClassDetailAfter(ClassModel kelas) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- STATUS MEMBER ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 16, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  "Terdaftar / Paid",
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // --- JUDUL & INFO ---
          Text(
            kelas.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _infoRow(Icons.calendar_today, kelas.date),
          const SizedBox(height: 10),
          _infoRow(Icons.access_time, kelas.time),
          const SizedBox(height: 10),
          _infoRow(Icons.location_on, "Ruang Body Pilates"), 

          const Spacer(),

          // --- INFO PENTING ---
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              "Silakan scan QR Code yang diberikan instruktur untuk melakukan absensi kehadiran.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),

          // =============================
          // TOMBOL CHECK-IN (SCAN QR)
          // =============================
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Warna beda dari tombol bayar
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
              onPressed: () {
                // Panggil method lokal sesuai diagram
                onQRClick(kelas.idClass);
              },
              label: const Text(
                "Check-In Kehadiran",
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onQRClick(String idClass) {
    controller.showQRScan(idClass);
  }

  // Helper UI Kecil
  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
      ],
    );
  }
}