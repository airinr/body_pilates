import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../data/models/notificationModel.dart';
import '../../data/models/memberModel.dart';

class NotificationController extends GetxController {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('notifications');

  final MemberModel member = Get.find<MemberModel>();

  var notificationList = <NotificationModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void fetchNotifications() async {
    isLoading.value = true;

    List<String> enrolledIds = [];
    final classesSnapshot = await FirebaseDatabase.instance
        .ref('classes')
        .get();

    if (classesSnapshot.exists && classesSnapshot.value is Map) {
      final classesData = Map<String, dynamic>.from(
        classesSnapshot.value as Map,
      );

      classesData.forEach((classId, classData) {
        if (classData['participants'] != null) {
          final participants = Map<String, dynamic>.from(
            classData['participants'],
          );
          if (participants.containsKey(member.uid)) {
            enrolledIds.add(classId);
          }
        }
      });
    }

    _db.onValue.listen((event) {
      final data = event.snapshot.value;
      final List<NotificationModel> temp = [];

      if (data != null && data is Map) {
        data.forEach((key, value) {
          final notif = NotificationModel.fromMap(
            key,
            Map<String, dynamic>.from(value),
          );

          if (enrolledIds.contains(notif.classId)) {
            temp.add(notif);
          }
        });
      }

      temp.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      notificationList.assignAll(temp);
      isLoading.value = false;
    });
  }
}
