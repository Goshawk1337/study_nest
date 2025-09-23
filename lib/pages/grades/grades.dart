import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_nest/utils/icons.dart';
import '../../services/grades.dart'; // the file with Grades + models
import '../../services/auth_controller.dart'; // your AuthController

class GradesPage extends StatefulWidget {
  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  final authController = Get.find<AuthController>();
  final gradesService = Get.put(Grades());

  List<Grade> grades = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGrades();
  }

  Future<void> _loadGrades({bool forceRefresh = false}) async {
    if (!authController.isLoggedIn) {
      Get.snackbar("Error", "You must log in first");
      return;
    }

    setState(() => isLoading = true);

    try {
      final loadedGrades = await gradesService.getGrades(
        accessToken: authController.accessToken.value!,
        instituteCode: authController.instituteCode.value!,
        forceRefresh: forceRefresh,
      );

      setState(() => grades = loadedGrades);
    } catch (e) {
      Get.snackbar("Error", "Failed to load grades: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Grades")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : grades.isEmpty
          ? Center(child: Text("No grades found."))
          : RefreshIndicator(
              onRefresh: () => _loadGrades(forceRefresh: true),
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: grades.length,
                itemBuilder: (context, index) {
                  final grade = grades[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          GradeIcon.getIcon(grade, size: 32),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  grade.subject?.name ?? "No subject",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  grade.theme ?? "No theme",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  grade.recordDateAsString != null
                                      ? DateTime.tryParse(
                                                  grade.recordDateAsString ??
                                                      "",
                                                ) !=
                                                null
                                            ? "${DateTime.parse(grade.recordDateAsString ?? "").year}-"
                                                  "${DateTime.parse(grade.recordDateAsString ?? "").month.toString().padLeft(2, '0')}-"
                                                  "${DateTime.parse(grade.recordDateAsString ?? "").day.toString().padLeft(2, '0')}"
                                            : grade.recordDateAsString!
                                      : "No Date",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              grade.numberValue?.toString() ?? "-",
                              style: TextStyle(
                                color: GradeIcon.getColorByGrade(grade),
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
