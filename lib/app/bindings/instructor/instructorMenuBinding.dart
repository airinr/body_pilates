import 'package:get/get.dart';
import '../../controller/instructor/InstructorMenuController.dart';

class InstructorMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<InstructorMenuController>(InstructorMenuController());
  }
}
