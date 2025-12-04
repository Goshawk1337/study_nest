import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../services/auth_controller.dart';
import '../models/base_models.dart';
import '../models/grade.dart';
import '../models/average.dart';

class KretaController extends GetxController {
  final authController = Get.find<AuthController>();

  List<Grade>? _cachedGrades;
  Object? studentName;

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

      _cachedGrades = Grade.listFromJson(data);
      _cachedGrades!.sort((a, b) {
        final aDate = a.recordDateAsString ?? '';
        final bDate = b.recordDateAsString ?? '';
        return bDate.compareTo(aDate);
      });
      print("Force refreshed grades");
      return _cachedGrades!;
    } else {
      throw Exception('Failed to load grades: ${response.statusCode}');
    }
  }

  Map<String, Average> getLocalAverages({String? uid}) {
    if (_cachedGrades == null) {
      // Cannot await in non-async method, fetch grades synchronously first
      // You should call getGrades() before calling getLocalAverages()
      return {};
     }

    final Map<String, List<Grade>> grouped = {};
    for (final grade in _cachedGrades!) {
      final subjectUid = grade.subject?.name.toLowerCase();
      if (subjectUid == null) continue;

      grouped.putIfAbsent(subjectUid, () => []);
      grouped[subjectUid]!.add(grade);
    }

    final Map<String, Average> averages = {};
    grouped.forEach((subjectUid, subjectGrades) {
      final numericGrades = subjectGrades
          .map((g) => g.numberValue)
          .whereType<num>()
          .toList();

      if (numericGrades.isEmpty) return;

      final avg = numericGrades.reduce((a, b) => a + b) / numericGrades.length;

      final lastGrade = subjectGrades.last;
      final avgWithTime = AverageWithTime(
        average: avg.toDouble(),
        dateAsString: lastGrade.recordDateAsString ?? '',
      );

      averages[subjectUid] = Average(
        averageNumber: avg.toDouble(),
        averagesInTime: avgWithTime,
        subject: subjectGrades.first.subject,
        uid: subjectUid,
      );
    });

    if (uid != null) {
      return averages.containsKey(uid) ? {uid: averages[uid]!} : {};
    }

    return averages;
  }

  Average? getAllTimeAverage() {
    final localAverages = getLocalAverages();
    if (localAverages.isEmpty) return null;

    final avgValues = localAverages.values
        .map((a) => a.averageNumber)
        .whereType<double>()
        .toList();

    if (avgValues.isEmpty) return null;

    final totalAvg = avgValues.reduce((a, b) => a + b) / avgValues.length;

    return Average(
      averageNumber: totalAvg,
      averagesInTime: AverageWithTime(
        average: totalAvg,
        dateAsString: DateTime.now().toIso8601String(),
      ),
      uid: 'all_time',
      subject: SubjectDescriptor(
        uid: 'all_time',
        name: 'All Subjects', category: ValueDescriptor(uid: 'all_time', name: 'All Categories', description: ''),
      ),
    );
  }

  void clearGradeCache() {
    _cachedGrades = null;
  }

  Future<String?> getName({bool forceRefresh = false}) async {
    // if (studentName != null) {
    //   return studentName;
    // }
    final response = await http.get(
      Uri.parse(
        'https://${authController.instituteCode}.e-kreta.hu/ellenorzo/v3/sajat/TanuloAdatlap',
      ),
      headers: {
        'Authorization': 'Bearer ${authController.accessToken}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      studentName = data['Nev'] as String?;

      return studentName as String?;
    } else {
      throw Exception('Failed to load student name: ${response.statusCode}');
    }
  }
}
