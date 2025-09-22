import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';
import '../pages/login/login.dart';
import '../navigation_menu.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Obx(() {
      if (auth.isLoggedIn) {
        return NavigationMenu();
      } else {
        return LoginPage();
      }
    });
  }
}
