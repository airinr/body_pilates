import 'package:get/get.dart';
import '../../controller/member/ClassBeforeController.dart';

class ClassBeforeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ClassBeforeController>(ClassBeforeController());
  }
}
