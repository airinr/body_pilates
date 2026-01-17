import 'package:get/get.dart';
import '../controller/AuthController.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}
