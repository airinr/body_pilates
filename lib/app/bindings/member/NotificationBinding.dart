import 'package:get/get.dart';
import '../../controller/member/NotificationController.dart';

class Notificationbinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NotificationController>(NotificationController());
  }
}
