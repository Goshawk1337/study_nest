import 'package:flutter/material.dart';
import 'base_models.dart';
import 'package:study_nest/utils/icons.dart';

class Timetable {
  final SubjectDescriptor? subject;

  const Timetable({
    this.subject
  });

  factory Timetable.fromJson(Map<String, dynamic> json) {
    return Timetable(
      // creatingTimeAsString: json['KeszitesDatuma'] as String?,
      // form: json['Jelleg'] as String?,
      // formType: json['ErtekFajta'] != null
      //     ? ValueDescriptor.fromJson(json['ErtekFajta'] as Map<String, dynamic>)
      //     : null,
      // group: json['OsztalyCsoport'] != null
      //     ? UidStructure.fromJson(json['OsztalyCsoport'] as Map<String, dynamic>)
      //     : null,
      // mode: json['Mod'] != null
      //     ? ValueDescriptor.fromJson(json['Mod'] as Map<String, dynamic>)
      //     : null,
      // numberValue: json['SzamErtek'] as int?,
      // recordDateAsString: json['RogzitesDatuma'] as String?,
      // seenByTutelaryAsString: json['LattamozasDatuma'] as String?,
      // shortValue: json['SzovegesErtekelesRovidNev'] as String?,
      // sortIndex: json['SortIndex'] as int?,
      subject: json['Tantargy'] != null
          ? SubjectDescriptor.fromJson(json['Tantargy'] as Map<String, dynamic>)
          : null,
      // teacher: json['ErtekeloTanarNeve'] as String?,
      // theme: json['Tema'] as String?,
      // type: json['Tipus'] != null
      //     ? ValueDescriptor.fromJson(json['Tipus'] as Map<String, dynamic>)
      //     : null,
      // uid: json['Uid'] as String?,
      // value: json['SzovegesErtek'] as String?,
      // weight: json['SulySzazalekErteke'] as int?,
    );
  }

  static List<Timetable> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Timetable.fromJson(json as Map<String, dynamic>)).toList();
  }

  Icon get icon => GradeIcon.getIcon(subjectName: subject?.category.name);
}
