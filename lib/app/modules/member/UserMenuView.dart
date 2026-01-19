import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import Controller dan Model
import '../../controller/member/UserMenuController.dart';
import '../../data/models/classModel.dart';

class UserMenuView extends GetView<UserMenuController> {
  const UserMenuView({super.key});

  void onLogoutClicked() {
    // Panggil logic di controller
    controller.logoutClicked();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Kita butuh 2 Tab
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Menu Member"),
          backgroundColor: Colors.pinkAccent,
          actions: [
            // Tombol Logout di pojok kanan atas
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: "Logout",
              onPressed: () {
                onLogoutClicked();
              },
            ),
          ],
          // INI BAGIAN TAB-NYA BRO
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.search),
                text: "Cari Kelas",
              ),
              Tab(
                icon: Icon(Icons.check_circle_outline),
                text: "Kelas Saya",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // TAB 1: List Kelas yang BELUM diambil (Available)
            Obx(() => _buildClassList(
                  classes: controller.availableClasses,
                  isEnrolled: false,
                )),

            // TAB 2: List Kelas yang SUDAH diambil (Enrolled)
            Obx(() => _buildClassList(
                  classes: controller.enrolledClasses,
                  isEnrolled: true,
                )),
          ],
        ),
      ),
    );
  }

  // Widget Pembantu untuk membuat List (Biar kodingan gak duplikat)
  // Ini merepresentasikan method 'showAllClasses' di diagram secara visual
  Widget _buildClassList({required List<ClassModel> classes, required bool isEnrolled}) {
    // Cek kalau list kosong
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
              isEnrolled ? "Belum ada kelas yang diikuti" : "Tidak ada kelas tersedia",
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      );
    }

    // Render List Kelas
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final item = classes[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            leading: CircleAvatar(
              backgroundColor: isEnrolled ? Colors.green[100] : Colors.pink[50],
              child: Icon(
                Icons.self_improvement, // Icon Pilates/Yoga
                color: isEnrolled ? Colors.green : Colors.pinkAccent,
              ),
            ),
            title: Text(
              item.title, // Judul Kelas
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text("${item.date} • ${item.time}"),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Rp ${item.price}",
                  style: const TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            trailing: Icon(
              isEnrolled ? Icons.arrow_forward_ios : Icons.add_circle_outline,
              size: 18,
              color: Colors.grey,
            ),
            onTap: () {
              // Panggil method controller untuk navigasi ke detail
              // Sesuai diagram: onClassClicked(idClass)
              controller.onClassClicked(item.idClass);
            },
          ),
        );
      },
    );
  }
}