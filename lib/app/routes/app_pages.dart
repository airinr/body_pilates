import 'package:body_pilates/app/bindings/instructor/addClassBinding.dart';
import 'package:body_pilates/app/bindings/instructor/instructorMenuBinding.dart';
import 'package:body_pilates/app/bindings/registerBindings.dart';
import 'package:body_pilates/app/modules/home/registerPage.dart';
import 'package:body_pilates/app/modules/instructor/AddClassView.dart';
import 'package:body_pilates/app/modules/instructor/InstructorMenuView.dart';
import 'package:get/get.dart';

import '../modules/home/loginPage.dart';
import '../bindings/loginBindings.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.register,
      page: () => RegisterPage(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.instructorMenu,
      page: () => InstructorMenuView(),
      binding: InstructorMenuBinding(),
    ),
    GetPage(
      name: Routes.addClass,
      page: () => AddClassView(),
      binding: AddClassBinding(),
    ),
  ];
}
