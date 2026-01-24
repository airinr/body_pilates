import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../data/models/classModel.dart';

class ClassAfterController extends GetxController {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('classes');

  // Variabel Reactive
  final Rx<ClassModel?> classDetail = Rx<ClassModel?>(null);
  final RxBool isLoading = true.obs;

  // ID Class diambil dari arguments saat navigasi masuk
  late String idClass;

  @override
  void onInit() {
    super.onInit();
    // Ambil ID dari halaman sebelumnya
    if (Get.arguments is Map) {
      idClass = Get.arguments['idClass'];
    } else {
      // Jaga-jaga kalau formatnya bukan Map
      idClass = Get.arguments.toString();
    }

    loadClassDetailAfter(idClass);
  }

  // Sesuai Diagram: loadClassDetailAfter(idClass: String)
  void loadClassDetailAfter(String idClass) {
    isLoading.value = true;
    _db
        .child(idClass)
        .once()
        .then((event) {
          final data = event.snapshot.value;
          if (data != null && data is Map) {
            classDetail.value = ClassModel.fromMap(
              idClass,
              Map<String, dynamic>.from(data),
            );
          }
          isLoading.value = false;
        })
        .catchError((e) {
          isLoading.value = false;
          Get.snackbar("Error", "Gagal memuat detail kelas");
        });
  }

  void showQRScan(String idClass) {
    Get.toNamed('/scan-qr', arguments: idClass);
  }
}
