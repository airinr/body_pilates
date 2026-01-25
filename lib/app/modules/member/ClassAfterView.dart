import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/member/ClassAfterController.dart';
import '../../data/models/classModel.dart';
import '../../data/models/memberModel.dart'; // Import buat ambil UID user login

class ClassAfterView extends GetView<ClassAfterController> {
  const ClassAfterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kelas Saya"), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final ClassModel? kelas = controller.classDetail.value;
        if (kelas == null) {
          return const Center(child: Text("Data kelas tidak ditemukan"));
        }

        return _buildClassDetailAfter(kelas);
      }),
    );
  }

  Widget _buildClassDetailAfter(ClassModel kelas) {
    // 1. Ambil UID User yang lagi login sekarang dari Memory
    final member = Get.find<MemberModel>();
    final String myUid = member.uid; 

    // 2. Cek Status Kehadiran pakai Helper tadi
    final bool isPresent = kelas.isUserPresent(myUid);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge Paid
          _buildStatusBadge("Terdaftar / Paid", Colors.green),
          
          const SizedBox(height: 16),
          Text(kelas.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          _infoRow(Icons.calendar_today, kelas.date),
          const SizedBox(height: 10),
          _infoRow(Icons.access_time, kelas.time),
          
          const Spacer(),

          // ===========================================
          // LOGIC GANTI TAMPILAN (TOMBOL vs CARD)
          // ===========================================
          if (isPresent) 
            // Kalau nama user ada di list checkedIn -> Tampilkan Kartu Hijau
            _buildSuccessCard()
          else 
            // Kalau belum ada -> Tampilkan Tombol Scan Biru
            _buildScanButton(kelas.idClass),
        ],
      ),
    );
  }

  // --- TAMPILAN 1: TOMBOL SCAN (BELUM HADIR) ---
  Widget _buildScanButton(String idClass) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
        onPressed: () => controller.showQRScan(idClass),
        label: const Text(
          "Check-In Kehadiran",
          style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // --- TAMPILAN 2: KARTU SUKSES (SUDAH HADIR) ---
  Widget _buildSuccessCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: const [
          Icon(Icons.check_circle, size: 40, color: Colors.green),
          SizedBox(height: 8),
          Text(
            "Kamu Sudah Hadir",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text("Selamat latihan!", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // Helper UI
  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 16, color: color),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}