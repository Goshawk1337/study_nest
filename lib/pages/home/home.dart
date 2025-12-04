import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:get/get.dart';
import 'package:study_nest/controllers/language_controller.dart';
import 'package:study_nest/controllers/kreta_controller.dart';

class HomePage extends StatelessWidget {
  final LanguageController languageController = Get.find<LanguageController>();
  final HomeData data = Get.put(HomeData());
  Future<void> _loadGrades({bool forceRefresh = false}) async {
 
    try {
      final loadedGrades = await data.kreta.getGrades(
        forceRefresh: forceRefresh,
      );

 
    } catch (e) {
      Get.snackbar("Error", "Failed to load grades: $e");
    } finally {}
  }
 
  @override
  Widget build(BuildContext context) {
      _loadGrades();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Study Nest",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,

        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            style: IconButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.grey.shade500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () {
              //TODO: Notifications
              return;
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 30.0),
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.center,
              width: double.infinity,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.blue.shade500,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.waving_hand, color: Colors.white, size: 32),
                  SizedBox(width: 12),
                  FutureBuilder<String>(
                    future: data.welcomeText(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          'error_greeting'.tr,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '10.A - Sigma School',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.grade, size: 32, color: Colors.blue),
                      SizedBox(height: 10),
                      FutureBuilder<String>(
                        future: data.getUserAverage(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              'N/A',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          } else {
                            return Text(
                              snapshot.data!,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomeData extends GetxController {
  final LanguageController languageController = Get.find<LanguageController>();
  final kreta = Get.put(KretaController());

  Future<String> getUserAverage() async {
    final allTimeAverage = kreta.getAllTimeAverage();

    if (allTimeAverage == null) return "N/A";
    return allTimeAverage?.averageNumber?.toStringAsFixed(2) ?? "Nincs átlag";
  }

  Future<String> welcomeText() async {
    final fullName = await kreta.getName();
    DateTime now = DateTime.now();
    int hour = now.hour;

    String? getFirstName(String fullName) {
      List<String> parts = fullName.trim().split(' ');
      if (parts.length < 2) return null; // No first name found
      return parts[1]; // The second word
    }

    final String? firstName = getFirstName(fullName!);

    String withName(String greeting) =>
        (getFirstName(fullName!)?.isNotEmpty == true)
        ? "$greeting $firstName"
        : greeting;

    if (hour >= 4 && hour < 6) {
      return withName("early_morning_greeting".tr);
    } else if (hour >= 6 && hour < 9) {
      return withName("morning_greeting".tr);
    } else if (hour >= 9 && hour < 12) {
      return withName("forenoon_greeting".tr);
    } else if (hour >= 12 && hour < 18) {
      return withName("afternoon_greeting".tr);
    } else if (hour >= 18 && hour < 20) {
      return withName("evening_greeting".tr);
    } else {
      return withName("night_greeting".tr);
    }
  }
}
