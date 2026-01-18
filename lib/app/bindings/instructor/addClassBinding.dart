import 'package:get/get.dart';
import '../../controller/instructor/AddClassController.dart';

class AddClassBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddClassController());
  }
}
