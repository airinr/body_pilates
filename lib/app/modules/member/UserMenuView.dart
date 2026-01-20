import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import Controller dan Model
import '../../controller/member/UserMenuController.dart';
import '../../data/models/classModel.dart';

class UserMenuView extends GetView<UserMenuController> {
  const UserMenuView({super.key});

  void onLogoutClicked() {
    controller.logoutClicked();
  }

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
              icon: const Icon(Icons.logout),
              onPressed: onLogoutClicked,
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
                if (isEnrolled) _paymentStatusBadge(item),
              ],
            ),
            trailing: isEnrolled
                ? (isPaid
                      ? const Icon(Icons.qr_code_scanner, color: Colors.green)
                      : const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                          color: Colors.grey,
                        ))
                : const Icon(Icons.add_circle_outline),
            onTap: () {
              if (!isEnrolled) {
                _showJoinDialog(item);
              } else if (!isPaid) {
                _showPaymentDialog(item);
              } else {
                _showScanQRDialog(item);
              }
            },
          ),
        );
      },
    );
  }

  // =============================
  // STATUS & HELPER
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

  Widget _paymentStatusBadge(ClassModel item) {
    final isPaid = _isPaid(item);

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

  // =============================
  // DIALOG JOIN
  // =============================

  void _showJoinDialog(ClassModel item) {
    Get.dialog(
      AlertDialog(
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow(Icons.calendar_today, "${item.date} • ${item.time}"),
            const SizedBox(height: 8),
            _infoRow(Icons.payments, "Rp ${item.price}"),
            const Divider(height: 24),
            const Text(
              "Apakah anda akan mengikuti kelas ini?",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text("Tutup")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
            onPressed: () {
              Get.back();
              controller.joinClass(item);
            },
            child: const Text("Ya, Ikuti"),
          ),
        ],
      ),
    );
  }

  // =============================
  // DIALOG PAYMENT
  // =============================

  void _showPaymentDialog(ClassModel item) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          "Pembayaran Kelas",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text("Total: Rp ${item.price}"),
            const SizedBox(height: 16),
            _buildDummyQRIS(),
            const SizedBox(height: 16),
            const Text(
              "Silakan scan QRIS untuk melakukan pembayaran",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              Get.back();
              await controller.markAsPaid(item);
            },
            child: const Text("Saya Sudah Bayar"),
          ),
        ],
      ),
    );
  }

  // =============================
  // DIALOG SCAN QR
  // =============================

  void _showScanQRDialog(ClassModel item) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          "Scan QR Check-in",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDummyQRIS(),
            const SizedBox(height: 12),
            const Text(
              "Tunjukkan QR ini ke instructor",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [TextButton(onPressed: Get.back, child: const Text("Tutup"))],
      ),
    );
  }
}

// =============================
// QRIS / QR DUMMY
// =============================
Widget _buildDummyQRIS() {
  return Container(
    width: 220,
    height: 220,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.qr_code, size: 120, color: Colors.black),
        SizedBox(height: 8),
        Text("QR DUMMY", style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
