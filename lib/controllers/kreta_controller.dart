import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../services/auth_controller.dart';
import '../models/grade.dart';

class KretaController extends GetxController {
  final authController = Get.find<AuthController>();

  List<Grade>? _cachedGrades;

  Future<List<Grade>> getGrades({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedGrades != null) {
      return _cachedGrades!;
    }

    final response = await http.get(
      Uri.parse(
        'https://${authController.instituteCode}.e-kreta.hu/ellenorzo/v3/sajat/Ertekelesek',
      ),
      headers: {
        'Authorization': 'Bearer ${authController.accessToken}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      print(data[2]);

      _cachedGrades = Grade.listFromJson(data);
      return _cachedGrades!;
    } else {
      throw Exception('Failed to load grades: ${response.statusCode}');
    }
  }

  void clearGradeCache() {
    _cachedGrades = null;
  }
}
