import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/member/UserMenuController.dart';
import '../../data/models/classModel.dart';
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
          backgroundColor: AppColors.primaryPink,
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
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(text: "Kelas Tersedia"),
              Tab(text: "Kelas Saya"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Available Classes
            _buildClassList(isEnrolledTab: false),
            // Tab 2: Enrolled Classes
            _buildClassList(isEnrolledTab: true),
          ],
        ),
      ),
    );
  }

  // Helper Widget untuk menangani List Kosong (Agar tidak crash)
  Widget _buildClassList({required bool isEnrolledTab}) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryPink),
        );
      }

      // Ambil data sesuai tab
      final List<ClassModel> listData = isEnrolledTab
          ? controller.enrolledClasses
          : controller.availableClasses;

      // ⛔ SAFETY CHECK: Agar tidak crash saat data kosong
      if (listData.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isEnrolledTab ? Icons.event_busy : Icons.search_off,
                size: 60,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                isEnrolledTab
                    ? "Kamu belum mengambil kelas apapun"
                    : "Tidak ada kelas baru tersedia",
                style: TextStyle(color: Colors.grey[500]),
              ),
            ],
          ),
        );
      }

      // Render List (Design Original Kamu)
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: listData.length,
        itemBuilder: (context, index) {
          final kelas = listData[index];
          // Cek status bayar (hanya relevan untuk tab enrolled)
          bool isPaid = false;
          if (isEnrolledTab) {
            isPaid = _isPaid(kelas);
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
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
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                // ✅ Panggil Logic Navigasi di Controller
                onTap: () => controller.onClassClicked(kelas),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.softPink.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.fitness_center,
                                    size: 16, color: AppColors.primaryPink),
                                SizedBox(width: 4),
                                Text(
                                  "Pilates",
                                  style: TextStyle(
                                    color: AppColors.darkPink,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isEnrolledTab) _paymentStatusBadge(isPaid),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        kelas.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(kelas.date,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 13)),
                          const SizedBox(width: 16),
                          Icon(Icons.access_time_rounded,
                              size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(kelas.time,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Rp ${kelas.price}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryPink,
                            ),
                          ),
                          if (!isEnrolledTab)
                            const Text(
                              "Daftar Sekarang >",
                              style: TextStyle(
                                  color: AppColors.primaryPink,
                                  fontWeight: FontWeight.w600),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  // Logic aman untuk cek payment
  bool _isPaid(ClassModel item) {
    try {
      final participant = item.participants[controller.member.uid];
      // Pastikan participant tidak null dan berbentuk Map
      if (participant != null && participant is Map) {
        return participant['paymentStatus'] == 'Paid';
      }
      return false;
    } catch (e) {
      return false;
    }
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
            ),
          ),
        ],
      ),
    );
  }
}