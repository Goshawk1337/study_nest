class ValueDescriptor {
  final String description;
  final String name;
  final String uid;

  const ValueDescriptor({
    required this.description,
    required this.name,
    required this.uid,
  });

  factory ValueDescriptor.fromJson(Map<String, dynamic> json) {
    return ValueDescriptor(
      description: json['Leiras'] as String,
      name: json['Nev'] as String,
      uid: json['Uid'] as String,
    );
  }
}

class UidStructure {
  final String uid;

  const UidStructure({required this.uid});

  factory UidStructure.fromJson(Map<String, dynamic> json) {
    return UidStructure(uid: json['Uid'] as String);
  }
}

class SubjectDescriptor {
  final String uid;
  final String name;
  final ValueDescriptor category;

  const SubjectDescriptor({
    required this.uid,
    required this.name,
    required this.category,
  });

  factory SubjectDescriptor.fromJson(Map<String, dynamic> json) {
    return SubjectDescriptor(
      uid: json['Uid'] as String,
      name: json['Nev'] as String,
      category: ValueDescriptor.fromJson(json['Kategoria'] as Map<String, dynamic>),
    );
  }
}

class Grade {
  final String? creatingTimeAsString;
  final String? form;
  final ValueDescriptor? formType;
  final UidStructure? group;
  final ValueDescriptor? mode;
  final int? numberValue;
  final String? recordDateAsString;
  final String? seenByTutelaryAsString;
  final String? shortValue;
  final int? sortIndex;
  final SubjectDescriptor? subject;
  final String? teacher;
  final String? theme;
  final ValueDescriptor? type;
  final String? uid;
  final String? value;
  final int? weight;

  const Grade({
    this.creatingTimeAsString,
    this.form,
    this.formType,
    this.group,
    this.mode,
    this.numberValue,
    this.recordDateAsString,
    this.seenByTutelaryAsString,
    this.shortValue,
    this.sortIndex,
    this.subject,
    this.teacher,
    this.theme,
    this.type,
    this.uid,
    this.value,
    this.weight,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      creatingTimeAsString: json['KeszitesDatuma'] as String?,
      form: json['Jelleg'] as String?,
      formType: json['ErtekFajta'] != null
          ? ValueDescriptor.fromJson(json['ErtekFajta'] as Map<String, dynamic>)
          : null,
      group: json['OsztalyCsoport'] != null
          ? UidStructure.fromJson(json['OsztalyCsoport'] as Map<String, dynamic>)
          : null,
      mode: json['Mod'] != null
          ? ValueDescriptor.fromJson(json['Mod'] as Map<String, dynamic>)
          : null,
      numberValue: json['SzamErtek'] as int?,
      recordDateAsString: json['RogzitesDatuma'] as String?,
      seenByTutelaryAsString: json['LattamozasDatuma'] as String?,
      shortValue: json['SzovegesErtekelesRovidNev'] as String?,
      sortIndex: json['SortIndex'] as int?,
      subject: json['Tantargy'] != null
          ? SubjectDescriptor.fromJson(json['Tantargy'] as Map<String, dynamic>)
          : null,
      teacher: json['ErtekeloTanarNeve'] as String?,
      theme: json['Tema'] as String?,
      type: json['Tipus'] != null
          ? ValueDescriptor.fromJson(json['Tipus'] as Map<String, dynamic>)
          : null,
      uid: json['Uid'] as String?,
      value: json['SzovegesErtek'] as String?,
      weight: json['SulySzazalekErteke'] as int?,
    );
  }

  static List<Grade> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Grade.fromJson(json as Map<String, dynamic>)).toList();
  }
}
