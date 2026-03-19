class StudentLanguageModel {
  final int? id;
  final DateTime? createdAt;
  final String? language;

  StudentLanguageModel({this.id, this.createdAt, this.language});

  factory StudentLanguageModel.fromJson(Map<String, dynamic> json) {
    return StudentLanguageModel(
      id: json['id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      language: json['language'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'language': language,
    };
  }
}
