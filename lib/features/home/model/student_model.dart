import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/features/profile/model/user_model.dart';

import 'attempt_phrases_model.dart';

class Student {
  int? id;
  DateTime? createdAt;
  String? userId;
  UserModel? user;
  int? classId;
  int? vocab;
  int? effort;
  int? score;
  List<AttemptedPhrase>? attemptedPhrases;

  Student({
    this.id,
    this.createdAt,
    this.userId,
    this.classId,
    this.vocab,
    this.effort,
    this.score,
    this.attemptedPhrases,
    this.user,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      userId: json['user_id'],
      classId: json['class'],
      vocab: json['vocab'],
      effort: json['effort'],
      score: json['score'],
      attemptedPhrases: (json['attempted_phrases'] as List?)
          ?.map((e) => AttemptedPhrase.fromJson(e))
          .toList(),

      user: json[DbTable.users] is Map
          ? UserModel.fromJson(json[DbTable.users])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'user_id': userId,
      'class': classId,
      'vocab': vocab,
      'effort': effort,
      'score': score,
    };
  }
}
