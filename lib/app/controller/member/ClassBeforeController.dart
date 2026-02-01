import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/classModel.dart';
import '../../data/models/memberModel.dart';

class ClassBeforeController extends GetxController {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('classes');

  MemberModel get member => Get.find<MemberModel>();

  late String idClass;
  late String userId;

  final Rx<ClassModel?> classDetail = Rx<ClassModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Map) {
      idClass = Get.arguments['idClass'];
      userId = Get.arguments['idUser'];
    }
    loadClassDetailBefore(idClass);
  }

  // 1. loadClassDetailBefore(idClass)
  void loadClassDetailBefore(String idClass) async {
    isLoading.value = true;
    try {
      final snapshot = await _db.child(idClass).get();
      if (snapshot.exists) {
        if (snapshot.value is Map) {
           classDetail.value = ClassModel.fromMap(
            idClass,
            Map<dynamic, dynamic>.from(snapshot.value as Map),
          );
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat detail kelas");
    } finally {
      isLoading.value = false;
    }
  }

  // 2. addClassMember(idClass, idUser)
  // FUNGSI: Menyimpan data peserta ke database (Dipanggil oleh PaymentController nanti)
  Future<void> addClassMember(String idClass, String idUser) async {
    // Simpan ke Realtime Database (Participants Class)
    await _db.child(idClass).child('participants').child(idUser).set({
      'memberId': idUser,
      'memberName': member.fullName,
      'joinedAt': DateTime.now().toIso8601String(),
      'paymentStatus': 'Paid',
    });

    // Simpan ke Firestore (User Profile - Riwayat Kelas)
    await FirebaseFirestore.instance.collection('users').doc(idUser).set({
      'enrolledClassIds': FieldValue.arrayUnion([idClass]),
    }, SetOptions(merge: true));

    // Update data lokal di MemberModel (Memory)
    member.enrollClass(idClass);
  }
}