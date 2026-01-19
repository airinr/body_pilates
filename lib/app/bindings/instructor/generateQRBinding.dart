import 'package:get/get.dart';
import '../../controller/instructor/GenerateQRController.dart';

class GenerateQRBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenerateQRController>(() => GenerateQRController());
  }
}
