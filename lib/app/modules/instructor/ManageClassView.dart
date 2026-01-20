import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/instructor/ManageClassController.dart';

class ManageClassView extends GetView<ManageClassController> {
  const ManageClassView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Manage Kelas"),
          backgroundColor: Colors.pinkAccent,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.edit), text: "Detail Kelas"),
              Tab(icon: Icon(Icons.check_circle), text: "Sudah Bayar"),
              Tab(icon: Icon(Icons.error_outline), text: "Belum Bayar"),
            ],
          ),
        ),
        body: Obx(
          () => TabBarView(
            children: [
              _buildDetailTab(),
              _buildParticipantTab(
                title: "Peserta Sudah Bayar",
                participants: controller.paidParticipants,
                icon: Icons.check_circle,
                color: Colors.green,
                emptyText: "Belum ada peserta yang sudah bayar",
              ),
              _buildParticipantTab(
                title: "Peserta Belum Bayar",
                participants: controller.unpaidParticipants,
                icon: Icons.error_outline,
                color: Colors.orange,
                emptyText: "Semua peserta sudah bayar",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================
  // TAB 1: DETAIL KELAS
  // =============================

  Widget _buildDetailTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionTitle("Detail Kelas"),
        _inputField(
          label: "Nama Kelas",
          controller: controller.titleController,
        ),
        _inputField(
          label: "Tanggal (YYYY-MM-DD)",
          controller: controller.dateController,
        ),
        _inputField(label: "Waktu", controller: controller.timeController),
        _inputField(
          label: "Harga (Rp)",
          controller: controller.priceController,
          keyboardType: TextInputType.number,
        ),

        const SizedBox(height: 30),

        ElevatedButton.icon(
          icon: const Icon(Icons.save),
          label: const Text("Simpan Perubahan"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pinkAccent,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () {
            Get.defaultDialog(
              title: "Simpan Perubahan?",
              middleText: "Apakah anda yakin ingin menyimpan perubahan kelas?",
              textConfirm: "Simpan",
              textCancel: "Batal",
              confirmTextColor: Colors.white,
              buttonColor: Colors.pinkAccent,
              onConfirm: () {
                Get.back();
                controller.submitEdit();
              },
            );
          },
        ),

        const SizedBox(height: 16),

        OutlinedButton.icon(
          icon: const Icon(Icons.delete, color: Colors.red),
          label: const Text("Hapus Kelas", style: TextStyle(color: Colors.red)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () {
            Get.defaultDialog(
              title: "Hapus Kelas?",
              middleText:
                  "Data kelas dan peserta akan dihapus secara permanen.",
              textConfirm: "Ya, Hapus",
              textCancel: "Batal",
              confirmTextColor: Colors.white,
              buttonColor: Colors.red,
              onConfirm: () {
                Get.back();
                controller.confirmDelete();
              },
            );
          },
        ),
      ],
    );
  }

  // =============================
  // TAB 2 & 3: PARTICIPANTS
  // =============================

  Widget _buildParticipantTab({
    required String title,
    required Map<String, dynamic> participants,
    required IconData icon,
    required Color color,
    required String emptyText,
  }) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionTitle(title),
        participants.isEmpty
            ? Text(emptyText, style: TextStyle(color: Colors.grey[600]))
            : Column(
                children: participants.entries.map((entry) {
                  final data = entry.value;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: color.withOpacity(0.15),
                        child: Icon(icon, color: color),
                      ),
                      title: Text(data['memberName'] ?? data['memberId']),
                      subtitle: Text(
                        "Join: ${data['joinedAt']}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }

  // =============================
  // HELPER WIDGET
  // =============================

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
