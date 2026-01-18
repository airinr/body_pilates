import 'dart:async';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../data/models/classModel.dart';

class InstructorMenuController extends GetxController {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('classes');

  final RxList<ClassModel> classList = <ClassModel>[].obs;
  final RxBool isLoading = false.obs;

  StreamSubscription<DatabaseEvent>? _classSubscription;

  @override
  void onInit() {
    super.onInit();
    fetchClasses();
  }

  void fetchClasses() {
    isLoading.value = true;

    _classSubscription?.cancel();

    _classSubscription = _db.onValue.listen(
      (event) {
        final data = event.snapshot.value;
        final List<ClassModel> temp = [];

        if (data is Map) {
          data.forEach((key, value) {
            if (value is Map) {
              temp.add(
                ClassModel.fromMap(
                  key.toString(),
                  Map<String, dynamic>.from(value),
                ),
              );
            }
          });
        }

        classList.assignAll(temp);
        isLoading.value = false;
      },
      onError: (error) {
        isLoading.value = false;
        Get.snackbar('Error', 'Gagal mengambil data kelas');
      },
    );
  }

  void addClass({
    required String title,
    required String date,
    required String time,
    required int price,
  }) async {
    try {
      await _db.push().set({
        'title': title,
        'date': date,
        'time': time,
        'price': price,
      });
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambah kelas');
    }
  }

  void deleteClass(String idClass) async {
    try {
      await _db.child(idClass).remove();
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus kelas');
    }
  }

  @override
  void onClose() {
    _classSubscription?.cancel();
    super.onClose();
  }
}
