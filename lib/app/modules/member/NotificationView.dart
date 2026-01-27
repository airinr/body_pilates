import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/member/NotificationController.dart';
import '../../core/theme/app_colors.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPink, // Background Biru Muda
      appBar: AppBar(
        title: const Text(
          "Kotak Masuk",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryPink, // Biru Utama
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryPink),
          );
        }

        if (controller.notificationList.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.notificationList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = controller.notificationList[index];
            return _buildNotificationItem(item);
          },
        );
      }),
    );
  }

  // =============================
  // WIDGET ITEMS
  // =============================

  Widget _buildNotificationItem(dynamic item) {
    // Format Tanggal
    final date = DateTime.fromMillisecondsSinceEpoch(item.timestamp);
    final dateString =
        "${date.day}/${date.month} • ${date.hour}:${date.minute.toString().padLeft(2, '0')}";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. ICON BULAT
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.backgroundPink, // Biru sangat muda
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_rounded,
              color: AppColors.primaryPink, // Icon Biru
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // 2. KONTEN TEKS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Judul & Tanggal)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      dateString,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Isi Pesan
                Text(
                  item.message,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 13,
                    height: 1.4, // Spasi antar baris agar mudah dibaca
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.softPink.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_rounded,
              size: 64,
              color: AppColors.primaryPink.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Tidak ada notifikasi",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Kami akan memberi tahu Anda\njika ada kabar terbaru.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
