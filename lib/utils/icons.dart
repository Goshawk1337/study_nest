import 'package:flutter/material.dart';
import '../models/grade.dart';
import 'package:flutter/material.dart';

class GradeIcon {
  static Icon getIcon({
    String? subjectName,
    String? typeName,
    int? numberValue,
    double size = 32,
  }) {
    if (subjectName != null) {
      final s = subjectName.toLowerCase();

      switch (s) {
        case 'matematika':
          return Icon(Icons.calculate, color: Colors.white, size: size);
        case 'biológia':
          return Icon(Icons.eco, color: Colors.white, size: size);
        case 'történelem':
          return Icon(Icons.history_edu, color: Colors.white, size: size);
        case 'fizika':
          return Icon(Icons.science, color: Colors.white, size: size);
        case 'kémia':
          return Icon(Icons.science_outlined, color: Colors.white, size: size);
        case 'földrajz':
          return Icon(Icons.public, color: Colors.white, size: size);
        case 'zene':
          return Icon(Icons.music_note, color: Colors.white, size: size);
        case 'rajz':
          return Icon(Icons.brush, color: Colors.white, size: size);
        case 'testnevelés':
          return Icon(Icons.directions_run, color: Colors.white, size: size);
        case 'irodalom':
          return Icon(Icons.menu_book, color: Colors.white, size: size);
        case 'nyelvtan':
          return Icon(Icons.book, color: Colors.white, size: size);
        case 'informatika':
        case 'it':
        case 'technologia':
          return Icon(Icons.computer, color: Colors.white, size: size);
        case 'programozás':
        case 'code':
          return Icon(Icons.code, color: Colors.white, size: size);
        case 'hálózat':
        case 'networking':
          return Icon(Icons.cloud, color: Colors.white, size: size);
        case 'adatbázis':
        case 'database':
          return Icon(Icons.storage, color: Colors.white, size: size);
        case 'gazdaság':
        case 'economics':
          return Icon(Icons.bar_chart, color: Colors.white, size: size);
        case 'színház':
          return Icon(Icons.theater_comedy, color: Colors.white, size: size);
        case 'film':
          return Icon(Icons.movie, color: Colors.white, size: size);
        case 'technika':
          return Icon(Icons.build, color: Colors.white, size: size);
        case 'filozófia':
          return Icon(Icons.psychology, color: Colors.white, size: size);
        case 'nyelv':
        case 'language':
          return Icon(Icons.language, color: Colors.white, size: size);
        case 'vallás':
        case 'religion':
          return Icon(Icons.church, color: Colors.white, size: size);
        case 'környezet':
        case 'env':
          return Icon(Icons.park, color: Colors.white, size: size);
        case 'zene és tánc':
        case 'dance':
          return Icon(Icons.music_video, color: Colors.white, size: size);
        case 'filozófia és etika':
          return Icon(Icons.self_improvement, color: Colors.white, size: size);
        case 'projekt':
        case 'project':
          return Icon(Icons.task, color: Colors.white, size: size);
        default:
          return Icon(Icons.school, color: Colors.white, size: size);
      }
    }

    if (typeName?.toLowerCase() == 'dolgozat') {
      return Icon(Icons.assignment, color: Colors.white, size: size);
    }

    if (numberValue != null) {
      return Icon(Icons.school, color: getColorByNumber(numberValue), size: size);
    }

    return Icon(Icons.school, color: Colors.white, size: size);
  }

  static Color getColorByNumber(int value) {
    if (value >= 5) return Colors.lightGreenAccent.shade700;
    if (value == 4) return Colors.greenAccent;
    if (value == 3) return Colors.amberAccent;
    if (value == 2) return Colors.orangeAccent;
    if (value == 1) return Colors.redAccent;
    return Colors.blueGrey;
  }
}