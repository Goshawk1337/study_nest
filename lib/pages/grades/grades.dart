import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/grades.dart';
import '../../services/auth_controller.dart';

class GradesPage extends StatefulWidget {
  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>(); // get auth data
    final gradesService = Get.put(Grades());

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            if (!authController.isLoggedIn) {
              Get.snackbar("Error", "You must log in first");
              return;
            }

            final grades = await gradesService.getGrades(
              accessToken: authController.accessToken.value!,
              instituteCode: authController.instituteCode.value!,
            );

            // Debug print or show in snackbar
            print(grades);
            Get.snackbar("Grades loaded", "Found ${grades.length} grades");
          },
          child: const Text("Skibidi jegy"),
        ),
      ),
    );
  }
}
