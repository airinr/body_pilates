import 'package:get/get.dart';
import '../../controller/member/ClassAfterController.dart';

class ClassAfterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ClassAfterController>(ClassAfterController());
  }
}