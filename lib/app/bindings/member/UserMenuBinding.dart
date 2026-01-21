import 'package:get/get.dart';
import '../../controller/member/UserMenuController.dart';

class UserMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserMenuController());
  }
}