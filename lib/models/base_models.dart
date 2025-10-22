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