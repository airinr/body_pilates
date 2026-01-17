import 'package:body_pilates/app/bindings/registerBindings.dart';
import 'package:body_pilates/app/modules/home/registerPage.dart';
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
  ];
}
