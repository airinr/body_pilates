import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/member/UserMenuController.dart';
import '../../data/models/classModel.dart';

class UserMenuView extends GetView<UserMenuController> {
  const UserMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Menu Member"),
          backgroundColor: Colors.pinkAccent,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: controller.notificationClicked,
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: controller.logoutClicked,
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.search), text: "Cari Kelas"),
              Tab(icon: Icon(Icons.check_circle_outline), text: "Kelas Saya"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Obx(
              () => _buildClassList(
                classes: controller.availableClasses,
                isEnrolled: false,
              ),
            ),
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
  // LIST KELAS (HANYA UI + NAVIGASI)
  // =============================
  Widget _buildClassList({
    required List<ClassModel> classes,
    required bool isEnrolled,
  }) {
    if (classes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isEnrolled ? Icons.event_busy : Icons.search_off,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              isEnrolled
                  ? "Belum ada kelas yang diikuti"
                  : "Tidak ada kelas tersedia",
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: classes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = classes[index];
        final isPaid = _isPaid(item);

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 16,
            ),
            leading: CircleAvatar(
              backgroundColor: isEnrolled ? Colors.green[100] : Colors.pink[50],
              child: Icon(
                Icons.self_improvement,
                color: isEnrolled ? Colors.green : Colors.pinkAccent,
              ),
            ),
            title: Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                _infoRow(Icons.calendar_today, "${item.date} • ${item.time}"),
                const SizedBox(height: 4),
                _infoRow(Icons.payments, "Rp ${item.price}"),
                if (isEnrolled) const SizedBox(height: 6),
                if (isEnrolled) _paymentStatusBadge(isPaid),
              ],
            ),
            trailing: Icon(
              !isEnrolled
                  ? Icons.arrow_forward_ios_rounded
                  : isPaid
                  ? Icons.qr_code_scanner
                  : Icons.payments,
              size: 18,
              color: isPaid ? Colors.green : Colors.grey,
            ),

            // 🔥 NAVIGASI SESUAI FLOW UML
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
          ),
        );
      },
    );
  }

  // =============================
  // HELPER
  // =============================
  bool _isPaid(ClassModel item) {
    final participant = item.participants[controller.member.uid];
    return participant != null && participant['paymentStatus'] == 'Paid';
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }

  Widget _paymentStatusBadge(bool isPaid) {
    return Row(
      children: [
        Icon(
          isPaid ? Icons.check_circle : Icons.error_outline,
          size: 14,
          color: isPaid ? Colors.green : Colors.orange,
        ),
        const SizedBox(width: 4),
        Text(
          isPaid ? "Paid" : "Belum bayar",
          style: TextStyle(
            color: isPaid ? Colors.green : Colors.orange,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
