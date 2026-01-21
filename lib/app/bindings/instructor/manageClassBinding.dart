import 'package:get/get.dart';
import '../../controller/instructor/ManageClassController.dart';

class ManageClassBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ManageClassController>(ManageClassController());
  }
}