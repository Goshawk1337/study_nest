import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_nest/controllers/kreta_controller.dart';
import '../../models/grade.dart';
import 'package:study_nest/controllers/language_controller.dart';

class GradesPage extends StatefulWidget {
  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  final LanguageController languageController = Get.find<LanguageController>();
  final gradesService = Get.put(KretaController());

  List<Grade> grades = [];
  List<Grade> filteredGrades = [];
  bool isLoading = true;

  String? selectedSubject;
  List<String> allSubjects = [];

  @override
  void initState() {
    super.initState();
    _loadGrades();
  }

  dynamic avg;

  Future<void> _loadGrades({bool forceRefresh = false}) async {
    setState(() => isLoading = true);

    try {
      final loadedGrades = await gradesService.getGrades(
        forceRefresh: forceRefresh,
      );

      final subjects = loadedGrades
          .map((g) => g.subject?.name ?? "")
          .where((s) => s.isNotEmpty)
          .toSet()
          .toList();

      setState(() {
        grades = loadedGrades;
        allSubjects = subjects;
        filteredGrades = loadedGrades;
        selectedSubject = "";
        avg = gradesService.getAllTimeAverage()?.averageNumber?.toStringAsFixed(2) ?? "Nincs átlag";
      });
    } catch (e) {
      Get.snackbar("Error", "Failed to load grades: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _filterBySubject(String? subject) {
    setState(() {

      if (subject == null || subject.isEmpty) {
        filteredGrades = grades;
        selectedSubject = "";
        avg = gradesService.getAllTimeAverage()?.averageNumber?.toStringAsFixed(2) ?? "Nincs átlag";
      } else {
        selectedSubject = "$subject ";
        avg = gradesService.getLocalAverages()[subject.toLowerCase()]?.averageNumber?.toStringAsFixed(2) ?? "Nincs átlag";
        filteredGrades = grades
            .where(
              (g) => g.subject?.name.toLowerCase() == subject.toLowerCase(),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Grades")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: DropdownButtonFormField<String?>(
              isExpanded: true,
              decoration: InputDecoration(
                labelText: "Szűrő",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text("Összes tantárgy"),
                ),
                ...allSubjects.map(
                  (s) => DropdownMenuItem(value: s, child: Text(s)),
                ),
              ],
              onChanged: _filterBySubject,
            ),
          ),


          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.lightBlue,
              ),
              padding: EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    "${selectedSubject ?? ""}${('avg'.tr.isNotEmpty ? '${'avg'.tr[0].toUpperCase()}${'avg'.tr.substring(1)}' : 'avg'.tr)}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    avg ?? "Betöltés vagy nincs átlag.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Text(
                        "Osztályátlag",
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
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredGrades.isEmpty
                ? Center(child: Text("No grades found."))
                : RefreshIndicator(
                    onRefresh: () => _loadGrades(forceRefresh: true),
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: filteredGrades.length,
                      itemBuilder: (context, index) {
                        final grade = filteredGrades[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                grade.icon,
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        grade.subject?.name ?? "Nincs tantárgy",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 12,
                                        ),
                                        child: Text(
                                          grade.theme ?? "No theme",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                          softWrap: true,
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
                                    grade.numberValue?.toString() ?? "N/A",
                                    style: TextStyle(
                                      color: grade.color,
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
          ),
        ],
      ),
    );
  }
}
