import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:get/get.dart';
import 'package:study_nest/controllers/language_controller.dart';

class HomePage extends StatelessWidget {
  final LanguageController languageController = Get.find<LanguageController>();
  final HomeData data = Get.put(HomeData());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            data.welcomeText(),
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.blue,
              ),
              padding: EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    "next_class".tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Testnevelés",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Icon(Icons.access_alarm, color: Colors.white),
                      Text(
                        "08:00 - 08:45",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Icon(Icons.location_pin, color: Colors.white),
                      Text(
                        "Tornaterem",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.blue,
                ),
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(32, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.school, color: Colors.white, size: 32),

                              SizedBox(width: 16),

                              // Középső rész: tantárgy + dolgozat
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Matematika",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Dolgozat - 2025.09.13",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Jobb oldal: jegy körben
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "5",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeData extends GetxController {
  final LanguageController languageController = Get.find<LanguageController>();
  final RxString name = "Zsombor".obs;

  String welcomeText() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 4 && hour < 6) {
      // Hajnal
      return "early_morning_greeting".tr + name.value;
    } else if (hour >= 6 && hour < 9) {
      return "morning_greeting".tr + name.value;
    } else if (hour >= 9 && hour < 12) {
      return "forenoon_greeting".tr + name.value;
    } else if (hour >= 12 && hour < 18) {
      // Délután
      return "afternoon_greeting".tr + name.value;
    } else if (hour >= 18 && hour < 21) {
      // Este
      return "evening_greeting".tr + name.value;
    } else if ((hour >= 20 && hour < 24) || (hour >= 0 && hour < 4)) {
      // Éjszaka / Éjjel
      return "night_greeting".tr + name.value;
    } else {
      return "welcome".tr + name.value; // Fallback, ha valami furcsa történik
    }
  }
}
