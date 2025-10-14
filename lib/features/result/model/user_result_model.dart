class UserResult {
  int? id;
  DateTime? createdAt;
  String? userId;
  int? phrasesId;
  int? score;
  int? vocab;
  int? attempt;
  bool? scoreSubmitted;

  UserResult({
    this.id,
    this.createdAt,
    this.userId,
    this.phrasesId,
    this.score,
    this.vocab,
    this.attempt,
    this.scoreSubmitted,
  });

  factory UserResult.fromJson(Map<String, dynamic> json) {
    return UserResult(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      userId: json['user_id'],
      phrasesId: json['phrases_id'],
      score: json['score'],
      vocab: json['vocab'],
      attempt: json['attempt'],
      scoreSubmitted: json['score_submited'] != null
          ? (json['score_submited'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'user_id': userId,
      'phrases_id': phrasesId,
      'score': score,
      'vocab': vocab,
      'attempt': attempt,
      'score_submited': scoreSubmitted,
    };
  }
}
