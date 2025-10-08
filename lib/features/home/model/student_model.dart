import 'attempt_phrases_model.dart';
import 'classes_model.dart';

class Student {
  int? id;
  DateTime? createdAt;
  String? userId;
  int? classId;
  int? languageLevel;
  int? vocab;
  int? effort;
  int? score;
  List<AttemptedPhrase>? attemptedPhrases;
  Classes? classes;

  Student({
    this.id,
    this.createdAt,
    this.userId,
    this.classId,
    this.languageLevel,
    this.vocab,
    this.effort,
    this.score,
    this.attemptedPhrases,
    this.classes,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      userId: json['user_id'],
      classId: json['class'],
      languageLevel: json['language_level'],
      vocab: json['vocab'],
      effort: json['effort'],
      score: json['score'],
      attemptedPhrases: (json['attempted_phrases'] as List?)
          ?.map((e) => AttemptedPhrase.fromJson(e))
          .toList(),
      classes: json['classes'] != null
          ? Classes.fromJson(json['classes'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'user_id': userId,
      'class': classId,
      'language_level': languageLevel,
      'vocab': vocab,
      'effort': effort,
      'score': score,
    };
  }
}
