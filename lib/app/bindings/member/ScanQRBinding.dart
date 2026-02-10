import 'package:get/get.dart';
import '../../controller/member/ScanQRController.dart';

class ScanQRBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ScanQRController());
  }
}