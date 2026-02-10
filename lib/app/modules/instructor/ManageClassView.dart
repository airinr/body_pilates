import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/instructor/ManageClassController.dart';
import '../../core/theme/app_colors.dart';

class ManageClassView extends GetView<ManageClassController> {
  const ManageClassView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        backgroundColor: AppColors.backgroundPink,
        appBar: AppBar(
          title: const Text(
            "Kelola Kelas",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primaryPink,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Get.back(),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.softPink,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: [
              Tab(icon: Icon(Icons.edit_note_rounded), text: "Detail Kelas"),
              Tab(icon: Icon(Icons.people_alt_rounded), text: "Daftar Peserta"),
            ],
          ),
        ),
        body: Obx(
          () => TabBarView(
            children: [
              _buildDetailTab(context),

              _buildAllParticipantsTab(),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildDetailTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader("Informasi Kelas", Icons.info_outline_rounded),
                const SizedBox(height: 20),

                _buildModernField(
                  label: "Nama Kelas",
                  controller: controller.titleController,
                  icon: Icons.title_rounded,
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildModernField(
                        label: "Tanggal",
                        controller: controller.dateController,
                        icon: Icons.calendar_today_rounded,
                        readOnly: true,
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                            builder: (context, child) => Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: AppColors.primaryPink,
                                ),
                              ),
                              child: child!,
                            ),
                          );
                          if (picked != null) {
                            controller.dateController.text = picked
                                .toIso8601String()
                                .split('T')[0];
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildModernField(
                        label: "Waktu",
                        controller: controller.timeController,
                        icon: Icons.access_time_rounded,
                        readOnly: true,
                        onTap: () async {
                          TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (context, child) => Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: AppColors.primaryPink,
                                ),
                              ),
                              child: child!,
                            ),
                          );
                          if (picked != null) {
                            controller.timeController.text = picked.format(
                              context,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _buildModernField(
                  label: "Harga (Rp)",
                  controller: controller.priceController,
                  icon: Icons.monetization_on_outlined,
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save_rounded, color: Colors.white),
                    label: const Text(
                      "Simpan Perubahan",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPink,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _showConfirmationDialog(
                      title: "Simpan Perubahan?",
                      message:
                          "Informasi kelas akan diperbarui untuk semua peserta.",
                      confirmText: "Simpan",
                      confirmColor: AppColors.primaryPink,
                      onConfirm: controller.submitEdit,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red.shade100),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.red[700]),
                    const SizedBox(width: 10),
                    Text(
                      "Zona Berbahaya",
                      style: TextStyle(
                        color: Colors.red[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.red,
                    ),
                    label: const Text(
                      "Hapus Kelas Ini",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () => _showConfirmationDialog(
                      title: "Hapus Kelas?",
                      message:
                          "Data kelas dan riwayat peserta akan dihapus PERMANEN.",
                      confirmText: "Ya, Hapus",
                      confirmColor: Colors.red,
                      onConfirm: controller.confirmDelete,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAllParticipantsTab() {
    final paid = controller.paidParticipants;
    final unpaid = controller.unpaidParticipants;
    final bool isEmpty = paid.isEmpty && unpaid.isEmpty;

    if (isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.softPink.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.groups_rounded,
                size: 60,
                color: AppColors.primaryPink,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Belum ada peserta yang mendaftar",
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (paid.isNotEmpty) ...[
          _sectionHeader("Peserta Terdaftar", Icons.check_circle_rounded),
          const SizedBox(height: 10),
          ...paid.entries.map((e) => _buildParticipantCard(e.value, true)),
          const SizedBox(height: 20),
        ],

        if (unpaid.isNotEmpty) ...[
          _sectionHeader("Menunggu Pembayaran", Icons.pending_rounded),
          const SizedBox(height: 10),
          ...unpaid.entries.map((e) => _buildParticipantCard(e.value, false)),
        ],
      ],
    );
  }

  Widget _buildParticipantCard(dynamic data, bool isPaid) {
    final String name = data['memberName'] ?? data['memberId'] ?? 'Unknown';
    final Color statusColor = isPaid ? Colors.green : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: statusColor.withOpacity(0.1),
          child: Text(
            _getInitials(name),
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          "Bergabung: ${data['joinedAt'] ?? '-'}",
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: statusColor.withOpacity(0.2)),
          ),
          child: Text(
            isPaid ? "Lunas" : "Belum Bayar",
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }

  // =============================
  // HELPER WIDGETS
  // =============================

  String _getInitials(String name) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) return "?";

    List<String> nameSplit = trimmedName.split(RegExp(r'\s+'));

    String initials = "";
    if (nameSplit.isNotEmpty && nameSplit[0].isNotEmpty) {
      initials += nameSplit[0][0];
    }

    if (nameSplit.length > 1 && nameSplit[1].isNotEmpty) {
      initials += nameSplit[1][0];
    }

    return initials.toUpperCase();
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryPink, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.darkPink,
          ),
        ),
      ],
    );
  }

  Widget _buildModernField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            enabled: onTap == null,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.primaryPink, size: 22),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: AppColors.primaryPink, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showConfirmationDialog({
    required String title,
    required String message,
    required String confirmText,
    required Color confirmColor,
    required VoidCallback onConfirm,
  }) {
    Get.defaultDialog(
      title: title,
      titleStyle: TextStyle(color: confirmColor, fontWeight: FontWeight.bold),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(message, textAlign: TextAlign.center),
      ),
      confirm: SizedBox(
        width: 100,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: confirmColor),
          onPressed: () {
            Get.back();
            onConfirm();
          },
          child: Text(confirmText, style: const TextStyle(color: Colors.white)),
        ),
      ),
      cancel: SizedBox(
        width: 100,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.grey),
          onPressed: () => Get.back(),
          child: const Text("Batal"),
        ),
      ),
      radius: 16,
    );
  }
}
