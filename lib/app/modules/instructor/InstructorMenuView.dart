import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/classModel.dart';

class InstructorMenuView extends StatelessWidget {
  InstructorMenuView({super.key});

  final List<ClassModel> classes = [
    ClassModel(
      title: "Senam Pagi Ceria",
      level: "Beginner",
      schedule: "Senin & Rabu • 07.00",
      memberCount: 15,
    ),
    ClassModel(
      title: "Aerobik Power",
      level: "Intermediate",
      schedule: "Selasa & Kamis • 16.00",
      memberCount: 20,
    ),
    ClassModel(
      title: "Zumba Dance",
      level: "All Level",
      schedule: "Jumat • 18.30",
      memberCount: 25,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Instructor Dashboard"),
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.offAllNamed('/login');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add),
        onPressed: () {
          Get.snackbar("Info", "Tambah kelas (dummy)");
        },
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: classes.length,
        itemBuilder: (context, index) {
          final item = classes[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Chip(
                        label: Text(item.level),
                        backgroundColor: Colors.pink.shade50,
                      ),
                      const SizedBox(width: 8),
                      Text("👥 ${item.memberCount} member"),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "🕒 ${item.schedule}",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.snackbar("Detail", item.title);
                        },
                        child: const Text("Detail"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
