import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/instructor/ManageClassController.dart';

class ManageClassView extends GetView<ManageClassController> {
  const ManageClassView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Kelas"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // --- Form Input ---
            TextField(
              controller: controller.titleController,
              decoration: const InputDecoration(labelText: 'Nama Kelas'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller.dateController,
              decoration: const InputDecoration(labelText: 'Tanggal (YYYY-MM-DD)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller.timeController,
              decoration: const InputDecoration(labelText: 'Waktu'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller.priceController,
              decoration: const InputDecoration(labelText: 'Harga (Rp)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),

            // --- Tombol Submit Edit ---
            ElevatedButton(
              onPressed: () => controller.submitEdit(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text("Simpan Perubahan", style: TextStyle(color: Colors.white)),
            ),
            
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            // --- Tombol Hapus (Danger Zone) ---
            OutlinedButton.icon(
              onPressed: () {
                 // Tampilkan dialog konfirmasi biar aman
                 Get.defaultDialog(
                   title: "Hapus Kelas?",
                   middleText: "Data yang dihapus tidak bisa dikembalikan.",
                   textConfirm: "Ya, Hapus",
                   textCancel: "Batal",
                   confirmTextColor: Colors.white,
                   buttonColor: Colors.red,
                   onConfirm: () {
                     Get.back(); // Tutup dialog
                     controller.confirmDelete(); // Eksekusi hapus
                   }
                 );
              },
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text("Hapus Kelas Ini", style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}