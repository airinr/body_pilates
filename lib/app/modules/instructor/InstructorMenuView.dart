import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/instructor/InstructorMenuController.dart';
import '../../core/theme/app_colors.dart';

class InstructorMenuView extends GetView<InstructorMenuController> {
  const InstructorMenuView({super.key});

  // Method Wrapper
  void onLogoutClicked() => controller.logout();
  void onBroadcastClicked(idClass, className) =>
      controller.showBroadcastDialog(idClass, className);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPink, // Background Biru Muda
      appBar: AppBar(
        title: const Text(
          "Dashboard Instruktur",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryPink, // Biru Utama
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: onLogoutClicked,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryPink,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Buat Kelas", style: TextStyle(color: Colors.white)),
        onPressed: () => Get.toNamed('/addClass'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryPink),
          );
        }

        if (controller.classList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.class_outlined, size: 80, color: AppColors.softPink),
                const SizedBox(height: 16),
                Text(
                  "Belum ada kelas yang dibuat",
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.classList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = controller.classList[index];
            return _buildClassCard(item);
          },
        );
      }),
    );
  }

  Widget _buildClassCard(dynamic item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. HEADER: Judul & Harga
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundPink,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.fitness_center,
                    color: AppColors.primaryPink,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Rp ${item.price}",
                        style: const TextStyle(
                          color: AppColors.darkPink, // Biru Tua
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. INFO ROW (Tanggal & Jam)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildInfoChip(Icons.calendar_today_rounded, item.date),
                const SizedBox(width: 12),
                _buildInfoChip(Icons.access_time_rounded, item.time),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // 3. ACTION BUTTONS (Footer)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Tombol Scan QR
                _buildActionButton(
                  icon: Icons.qr_code_scanner_rounded,
                  label: "QR Kelas",
                  color: AppColors.primaryPink,
                  onTap: () => Get.toNamed('/generateQR', arguments: item),
                ),

                // Tombol Broadcast
                _buildActionButton(
                  icon: Icons.campaign_rounded,
                  label: "Broadcast",
                  color: Colors.orange,
                  onTap: () => onBroadcastClicked(item.idClass, item.title),
                ),

                // Tombol Detail
                _buildActionButton(
                  icon: Icons.edit_note_rounded,
                  label: "Detail",
                  color: Colors.grey,
                  onTap: () => Get.toNamed('/manageClass', arguments: item),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
      icon: Icon(icon, size: 20),
      label: Text(label),
    );
  }
}
