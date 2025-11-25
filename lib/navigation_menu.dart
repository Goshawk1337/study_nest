import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'pages/grades/grades.dart';
import 'pages/home/home.dart';
import 'pages/timetable/timetable.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
    bottomNavigationBar: Obx(
      () => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: controller.selectedIndex.value,
        selectedItemColor: Colors.amber,
        iconSize: 28,
        unselectedItemColor: Colors.grey,
        onTap: (value) => controller.selectedIndex.value = value,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "", tooltip: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grade), label: "", tooltip: 'Grades'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: "", tooltip: 'Órarend'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "", tooltip: 'Settings'),
        ],
      ),
    ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [HomePage(), GradesPage(), Timetable(), Container(color: Colors.red)];
}
