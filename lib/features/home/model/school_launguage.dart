import 'language_model.dart';

class SchoolLanguage {
  int? id;
  int? schoolId;
  Language? language;
  DateTime? createdAt;

  SchoolLanguage({this.id, this.schoolId, this.language, this.createdAt});

  factory SchoolLanguage.fromJson(Map<String, dynamic> json) {
    return SchoolLanguage(
      id: json['id'],
      schoolId: json['school'],
      language: json['language'] != null
          ? Language.fromJson(json['language'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'school': schoolId,
      'language': language?.toJson(),
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
