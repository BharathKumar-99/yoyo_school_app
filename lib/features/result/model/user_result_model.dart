import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';

import '../../profile/model/user_model.dart';

class UserResult {
  int? id;
  DateTime? createdAt;
  String? userId;
  int? phrasesId;
  int? score;
  int? vocab;
  int? attempt;
  bool? scoreSubmitted;
  List<String>? goodWords;
  List<String>? badWords;
  int? listen;
  int? highestScore;
  String? type;
  UserModel? user;
  PhraseModel? phrase;

  UserResult({
    this.id,
    this.createdAt,
    this.userId,
    this.phrasesId,
    this.score,
    this.vocab,
    this.attempt,
    this.scoreSubmitted,
    this.goodWords,
    this.badWords,
    this.listen,
    this.type,
    this.user,
    this.highestScore,
    this.phrase,
  });

  factory UserResult.fromJson(Map<String, dynamic> json) {
    return UserResult(
      id: json['id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      userId: json['user_id'] as String?,
      phrasesId: json['phrases_id'] is int ? json['phrases_id'] as int? : null,
      phrase: json[DbTable.phrase] is Map
          ? PhraseModel.fromJson(json[DbTable.phrase])
          : null,
      score: json['score'] as int?,
      vocab: json['vocab'] as int?,
      attempt: json['attempt'] as int?,
      highestScore: json['highest_score'] as int?,
      listen: json['listens'] as int?,
      scoreSubmitted: json['score_submited'] as bool?,
      goodWords: (json['good_words'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      badWords: (json['bad_words'] as List?)?.map((e) => e.toString()).toList(),
      type: json['type'] as String?,
      user: json[DbTable.users] != null
          ? UserModel.fromJson(json[DbTable.users])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (userId != null) 'user_id': userId,
      if (phrasesId != null) 'phrases_id': phrasesId,
      if (score != null) 'score': score,
      if (vocab != null) 'vocab': vocab,
      if (attempt != null) 'attempt': attempt,
      if (scoreSubmitted != null) 'score_submited': scoreSubmitted,
      if (goodWords != null) 'good_words': goodWords,
      if (badWords != null) 'bad_words': badWords,
      if (listen != null) 'listens': listen,
      if (type != null) 'type': type,
      if (highestScore != null) 'highest_score': highestScore,
    };
  }
}
