import 'phrases_model.dart';

class AttemptedPhrase {
  int? id;
  int? phrasesId;
  int? studentId;
  DateTime? createdAt;
  PhraseModel? phrase;

  AttemptedPhrase({
    this.id,
    this.phrasesId,
    this.studentId,
    this.createdAt,
    this.phrase,
  });

  factory AttemptedPhrase.fromJson(Map<String, dynamic> json) {
    return AttemptedPhrase(
      id: json['id'],
      phrasesId: json['phrases_id'],
      studentId: json['student_id'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      phrase: json['phrase'] != null
          ? PhraseModel.fromJson(json['phrase'])
          : null,
    );
  }
}
