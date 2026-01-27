import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/member/UserMenuController.dart';
import '../../data/models/classModel.dart';
// Pastikan path import AppColors ini benar sesuai struktur project Anda
import '../../core/theme/app_colors.dart';

class UserMenuView extends GetView<UserMenuController> {
  const UserMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            "Menu Member",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primaryPink, // Warna Biru Utama
          elevation: 0,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              tooltip: "Notifikasi",
              onPressed: controller.notificationClicked,
            ),
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              tooltip: "Keluar",
              onPressed: controller.logoutClicked,
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor:
                AppColors.softPink, // Biru muda untuk yang tidak dipilih
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: [
              // ✏️ PERUBAHAN DI SINI: Ganti Text & Icon
              Tab(
                icon: Icon(Icons.event_available_rounded),
                text: "Kelas Tersedia",
              ),
              Tab(
                icon: Icon(Icons.check_circle_outline_rounded),
                text: "Kelas Saya",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Kelas Tersedia
            Obx(
              () => _buildClassList(
                classes: controller.availableClasses,
                isEnrolled: false,
              ),
            ),
            // Tab 2: Kelas Saya
            Obx(
              () => _buildClassList(
                classes: controller.enrolledClasses,
                isEnrolled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================
  // LIST KELAS (UI + NAVIGASI)
  // =============================
  Widget _buildClassList({
    required List<ClassModel> classes,
    required bool isEnrolled,
  }) {
    // EMPTY STATE
    if (classes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.backgroundPink, // Biru sangat muda
                shape: BoxShape.circle,
              ),
              child: Icon(
                isEnrolled
                    ? Icons.event_busy_rounded
                    : Icons.search_off_rounded,
                size: 64,
                color: AppColors.softPink, // Biru muda/pastel
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isEnrolled
                  ? "Belum ada kelas yang diikuti"
                  : "Tidak ada kelas tersedia saat ini",
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      );
    }

    // LIST VIEW
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: classes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = classes[index];
        final isPaid = _isPaid(item);

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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              // 🔥 NAVIGASI
              onTap: () {
                if (!isEnrolled) {
                  Get.toNamed(
                    '/class-before',
                    arguments: {
                      'idClass': item.idClass,
                      'idUser': controller.member.uid,
                    },
                  );
                } else {
                  Get.toNamed(
                    '/class-after',
                    arguments: {'idClass': item.idClass},
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // 1. AVATAR ICON (Kiri)
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isEnrolled
                            ? const Color(
                                0xFFE8F5E9,
                              ) // Hijau muda jika enrolled
                            : AppColors
                                  .backgroundPink, // Biru muda jika available
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.self_improvement_rounded,
                        color: isEnrolled
                            ? Colors.green
                            : AppColors.primaryPink,
                        size: 30,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // 2. INFO TEXT (Tengah)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),

                          // Tanggal & Waktu
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${item.date} • ${item.time}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 4),

                          // Harga
                          Row(
                            children: [
                              Icon(
                                Icons.sell_outlined,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Rp ${item.price}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors
                                      .darkPink, // Harga pakai warna biru tua agar tegas
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          if (isEnrolled) ...[
                            const SizedBox(height: 8),
                            _paymentStatusBadge(isPaid),
                          ],
                        ],
                      ),
                    ),

                    // 3. ACTION ICON (Kanan)
                    Icon(
                      !isEnrolled
                          ? Icons.arrow_forward_ios_rounded
                          : isPaid
                          ? Icons.qr_code_2_rounded
                          : Icons.access_time_filled_rounded,
                      size: 20,
                      color: !isEnrolled
                          ? Colors.grey[300]
                          : isPaid
                          ? AppColors.primaryPink
                          : Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isPaid(ClassModel item) {
    final participant = item.participants[controller.member.uid];
    return participant != null && participant['paymentStatus'] == 'Paid';
  }

  Widget _paymentStatusBadge(bool isPaid) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPaid
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isPaid
              ? Colors.green.withOpacity(0.2)
              : Colors.orange.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPaid ? Icons.check_circle_rounded : Icons.pending_actions_rounded,
            size: 12,
            color: isPaid ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(
            isPaid ? "LUNAS" : "BELUM BAYAR",
            style: TextStyle(
              color: isPaid ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
