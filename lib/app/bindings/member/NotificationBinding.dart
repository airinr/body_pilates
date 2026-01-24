import 'package:get/get.dart';
import '../../controller/member/NotificationController.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NotificationController>(NotificationController());
  }
}
