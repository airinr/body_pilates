import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/instructor/InstructorMenuController.dart';

class InstructorMenuView extends GetView<InstructorMenuController> {
  const InstructorMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu Instructor"),
        backgroundColor: Colors.pinkAccent,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        onPressed: () {
          Get.toNamed('/addClass');
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.classList.isEmpty) {
          return const Center(child: Text("Belum ada kelas"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.classList.length,
          itemBuilder: (context, index) {
            final item = controller.classList[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                title: Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("📅 ${item.date}"),
                    Text("⏰ ${item.time}"),
                    Text("💰 Rp ${item.price}"),
                  ],
                ),
                trailing: TextButton(
                  onPressed: () {
                    Get.toNamed('/manageClass', arguments: item);
                  },
                  child: const Text(
                    "Detail",
                    style: TextStyle(
                      color: Colors
                          .blue, 
                      fontWeight:
                          FontWeight.bold, 
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
