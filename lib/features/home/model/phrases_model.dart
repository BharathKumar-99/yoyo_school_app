class PhraseModel {
  int? id;
  int? level;
  int? vocab;
  String? phrase;
  int? sounds;
  int? language;
  String? recording;
  DateTime? createdAt;
  String? translation;
  int? score;

  PhraseModel({
    this.id,
    this.level,
    this.vocab,
    this.phrase,
    this.sounds,
    this.language,
    this.recording,
    this.createdAt,
    this.translation,
    this.score,
  });

  factory PhraseModel.fromJson(Map<String, dynamic> json) {
    return PhraseModel(
      id: json['id'] as int?,
      level: json['level'] as int?,
      vocab: json['vocab'] as int?,
      phrase: json['phrase'] as String?,
      sounds: json['sounds'] as int?,
      language: json['language'] as int?,
      recording: json['recording'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      translation: json['translation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
      'vocab': vocab,
      'phrase': phrase,
      'sounds': sounds,
      'language': language,
      'recording': recording,
      'created_at': createdAt?.toIso8601String(),
      'translation': translation,
    };
  }
}
