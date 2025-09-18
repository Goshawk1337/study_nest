import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/languages.dart';

class LanguageController extends GetxController {
  var currentLanguage = 'en'.obs;

  @override
  void onInit() async {
    super.onInit();
    await loadLanguage();
  }

  /// Load language from SharedPreferences or use device locale
  Future<void> loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? savedLanguage = prefs.getString('language');

      if (savedLanguage != null) {
        currentLanguage.value = savedLanguage;
        debugPrint('Loaded saved language: $savedLanguage');
      } else {
        String deviceLanguage = Get.deviceLocale?.languageCode ?? 'hu';
        debugPrint('Device language: $deviceLanguage');
        /// Check if the device language is in the app supported languages
        if (AppTranslations.languageNames.containsKey(deviceLanguage)) {
          currentLanguage.value = deviceLanguage;
          debugPrint(  'Using device language: $deviceLanguage');
          await prefs.setString('language', deviceLanguage);
        } else {
          /// If the device language is not supported in the app default to english
          currentLanguage.value = 'hu';
        }
      }

      Get.updateLocale(Locale(currentLanguage.value));
    } catch (e) {
      log("Error loading language: $e");
    }
  }

  /// Set language and save to SharedPreferences
  Future<void> setLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', languageCode);
      currentLanguage.value = languageCode;
      Get.updateLocale(Locale(languageCode));
    } catch (e) {
      log("Error setting language: $e");
    }
  }
}