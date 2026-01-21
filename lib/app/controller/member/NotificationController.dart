import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../data/models/notificationModel.dart';
import '../../data/models/memberModel.dart';

class NotificationController extends GetxController {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('notifications');
  
  // Ambil data member buat filter
  final MemberModel member = Get.find<MemberModel>();

  // List notifikasi yang siap ditampilkan (Reactive)
  var notificationList = <NotificationModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void fetchNotifications() {
    // Listen real-time: Tiap ada notif baru, list otomatis update
    _db.onValue.listen((event) {
      final data = event.snapshot.value;
      final List<NotificationModel> temp = [];

      if (data != null && data is Map) {
        data.forEach((key, value) {
          final notif = NotificationModel.fromMap(key, Map<String, dynamic>.from(value));
          
          // 🔹 FILTER LOGIC:
          // Cuma ambil notifikasi kalau Class ID-nya ada di daftar enroll member
          if (member.isEnrolled(notif.classId)) {
            temp.add(notif);
          }
        });
      }

      // Sort biar yang terbaru paling atas (Descending by timestamp)
      temp.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      notificationList.assignAll(temp);
      isLoading.value = false;
    });
  }
}