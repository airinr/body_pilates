import 'package:get/get.dart';
import '../../controller/member/ClassBeforeController.dart';

class ClassBeforebinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ClassBeforeController>(ClassBeforeController());
  }
}
