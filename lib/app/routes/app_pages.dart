import 'package:body_pilates/app/bindings/instructor/addClassBinding.dart';
import 'package:body_pilates/app/bindings/instructor/generateQRBinding.dart';
import 'package:body_pilates/app/bindings/instructor/instructorMenuBinding.dart';
import 'package:body_pilates/app/bindings/instructor/manageClassBinding.dart';
import 'package:body_pilates/app/bindings/registerBindings.dart';
import 'package:body_pilates/app/modules/home/registerPage.dart';
import 'package:body_pilates/app/modules/instructor/AddClassView.dart';
import 'package:body_pilates/app/modules/instructor/GenerateQRView.dart';
import 'package:body_pilates/app/modules/instructor/InstructorMenuView.dart';
import 'package:body_pilates/app/modules/instructor/ManageClassView.dart';
import 'package:body_pilates/app/modules/member/ClassBeforeView.dart';
import 'package:get/get.dart';
import 'package:body_pilates/app/bindings/member/ClassBeforeBinding.dart';

// Package member
import '../bindings/member/UserMenuBinding.dart';
import '../modules/member/UserMenuView.dart';
import '../bindings/member/NotificationBinding.dart';
import '../modules/member/NotificationView.dart';
import '../bindings/member/ClassAfterBinding.dart';
import '../modules/member/ClassAfterView.dart';

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
    GetPage(
      name: Routes.manageClass,
      page: () => ManageClassView(),
      binding: ManageClassBinding(),
    ),
    GetPage(
      name: Routes.generateQR,
      page: () => GenerateQRView(),
      binding: GenerateQRBinding(),
    ),
    GetPage(
      name: Routes.userMenu,
      page: () => UserMenuView(),
      binding: UserMenuBinding(),
    ),
    GetPage(
      name: Routes.notification,
      page: () => NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: Routes.classBefore,
      page: () => ClassBeforeView(),
      binding: ClassBeforeBinding(),
    ),
    GetPage(
      name: Routes.classAfter,
      page: () => ClassAfterView(),
      binding: ClassAfterBinding(),
    )
  ];
}
