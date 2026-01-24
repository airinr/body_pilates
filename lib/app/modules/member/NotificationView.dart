import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/member/NotificationController.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifikasi"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notificationList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                const Text("Belum ada notifikasi baru"),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.notificationList.length,
          itemBuilder: (context, index) {
            final item = controller.notificationList[index];
            
            final date = DateTime.fromMillisecondsSinceEpoch(item.timestamp);
            final dateString = "${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.pink[50],
                  child: const Icon(Icons.info_outline, color: Colors.pinkAccent),
                ),
                title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(item.message),
                    const SizedBox(height: 8),
                    Text(
                      dateString, 
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                isThreeLine: true,
              ),
            );
          },
        );
      }),
    );
  }
}