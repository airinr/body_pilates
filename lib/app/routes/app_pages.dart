import 'package:get/get.dart';

import '../modules/home/loginPage.dart';
import '../bindings/loginBindings.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
  ];
}
