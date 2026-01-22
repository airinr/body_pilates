import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/member/ClassBeforeController.dart';
import '../../data/models/classModel.dart';

class ClassBeforeView extends GetView<ClassBeforeController> {
  const ClassBeforeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Kelas"), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final ClassModel? kelas = controller.classDetail.value;

        // ⛔ SAFETY CHECK
        if (kelas == null) {
          return const Center(child: Text("Data kelas tidak ditemukan"));
        }

        return _buildClassDetail(kelas);
      }),
    );
  }

  // =============================
  // DETAIL KELAS (BEFORE)
  // =============================
  Widget _buildClassDetail(ClassModel kelas) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            kelas.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          _infoRow(Icons.calendar_today, kelas.date),
          const SizedBox(height: 6),
          _infoRow(Icons.access_time, kelas.time),
          const SizedBox(height: 6),
          _infoRow(Icons.payments, "Rp ${kelas.price}"),

          const Spacer(),

          // =============================
          // PAY & JOIN
          // =============================
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () =>
                  controller.payClass(controller.userId, controller.idClass),
              child: const Text(
                "Bayar & Gabung Kelas",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================
  // HELPER UI
  // =============================
  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
