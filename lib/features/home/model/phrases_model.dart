import 'package:yoyo_school_app/config/utils/translate_funtions.dart';

class PhraseModel {
  int? id;
  int? level;
  int? vocab;
  String? phrase;
  int? sounds;
  int? language;
  String? recording;
  DateTime? createdAt;
  String? engTranslation;
  int? score;
  bool? warmup;
  String? questions;
  String? questionTranslation;
  String? questionRecording;
  int? categories;
  int? itemIndex;
  bool? readingPhrase;
  bool? listen;
  String? translatedText;
  String? questionTranslatedText;

  PhraseModel({
    this.id,
    this.level,
    this.vocab,
    this.phrase,
    this.sounds,
    this.language,
    this.recording,
    this.createdAt,
    this.engTranslation,
    this.score,
    this.questionRecording,
    this.questionTranslation,
    this.warmup,
    this.questions,
    this.categories,
    this.itemIndex,
    this.readingPhrase,
    this.listen,
    this.questionTranslatedText,
    this.translatedText,
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
      engTranslation: json['translation'] as String?,
      questionRecording: json['question_recording'] as String?,
      warmup: json['warmup'],
      questions: json['question'] == '' || json['question'] == null
          ? null
          : json['question'],
      questionTranslation: json['question_translation'],
      categories: json['categories'],
      itemIndex: json['item_index'],
      readingPhrase: json['reading_phrase'],
      listen: json['listen'],
      translatedText: null,
      questionTranslatedText: null,
    );
  }

  Future<void> translate() async {
    if (engTranslation == null || (engTranslation?.isEmpty ?? true)) return;

    translatedText ??= await TranslateFunctions().translateText(engTranslation);
    questionTranslatedText ??= await TranslateFunctions().translateText(
      questionTranslation,
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
      'translation': engTranslation,
      'warmup': warmup,
      'questions': questions,
      'question_translation': questionTranslation,
      'question_recording': questionRecording,
      'categories': categories,
      'item_index': itemIndex,
      'reading_phrase': readingPhrase,
      'listen': listen,
    };
  }
}
