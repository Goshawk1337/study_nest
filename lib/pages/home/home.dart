import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:get/get.dart';
import 'package:study_nest/controllers/language_controller.dart';


class HomePage extends StatelessWidget {
    final LanguageController languageController = Get.find<LanguageController>();
  
 
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text("title".tr)
      ),
      body: Center(
        child: Text(  " asd")
      ),
     );
  }
}

  