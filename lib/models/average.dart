import 'base_models.dart';

class AverageWithTime {
  final double average;
  final String dateAsString;

  const AverageWithTime({
    required this.average,
    required this.dateAsString,
  });

  factory AverageWithTime.fromJson(Map<String, dynamic> json) {
    return AverageWithTime(
      average: (json['Atlag'] as num).toDouble(),
      dateAsString: json['Datum'] as String,
    );
  }
}

class Average {
  final double? averageNumber; // main average
  final AverageWithTime? averagesInTime;
  final int? sortIndex;
  final SubjectDescriptor? subject;
  final double? sumOfWeightedEvaluations;
  final double? sumOfWeights;
  final String? uid;

  const Average({
    this.averageNumber,
    this.averagesInTime,
    this.sortIndex,
    this.subject,
    this.sumOfWeightedEvaluations,
    this.sumOfWeights,
    this.uid,
  });

  factory Average.fromJson(Map<String, dynamic> json) {
    return Average(
      averageNumber: (json['Atlag'] as num?)?.toDouble(),
      averagesInTime: json['AtlagAlakulasaIdoFuggvenyeben'] != null
          ? AverageWithTime.fromJson(
              json['AtlagAlakulasaIdoFuggvenyeben']
                  as Map<String, dynamic>,
            )
          : null,
      sortIndex: json['SortIndex'] as int?,
      subject: json['Tantargy'] != null
          ? SubjectDescriptor.fromJson(
              json['Tantargy'] as Map<String, dynamic>,
            )
          : null,
      sumOfWeightedEvaluations:
          (json['SulyozottOsztalyzatOsszege'] as num?)?.toDouble(),
      sumOfWeights:
          (json['SulyozottOsztalyzatSzama'] as num?)?.toDouble(),
      uid: json['Uid'] as String?,
    );
  }

  static List<Average> listFromJson(List<dynamic> jsonList) {
    return jsonList
        .map((json) => Average.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
