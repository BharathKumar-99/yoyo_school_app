class ListenModel {
  int? overallScore;
  int? wordAccuracy;
  int? phoneticAccuracy;
  int? grammarEndings;
  String? band;
  String? title;
  String? body;
  String? microTip;
  Map<String, dynamic>? words;

  ListenModel({
    this.overallScore,
    this.wordAccuracy,
    this.phoneticAccuracy,
    this.grammarEndings,
    this.band,
    this.title,
    this.body,
    this.microTip,
    this.words,
  });

  ListenModel.fromJson(Map<String, dynamic> json) {
    overallScore = json['overall_score'];
    wordAccuracy = json['word_accuracy'];
    phoneticAccuracy = json['phonetic_accuracy'];
    grammarEndings = json['grammar_endings'];
    band = json['band'];
    title = json['title'];
    body = json['body'];
    microTip = json['micro_tip'];
    words = json['words'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['overall_score'] = overallScore;
    data['word_accuracy'] = wordAccuracy;
    data['phonetic_accuracy'] = phoneticAccuracy;
    data['grammar_endings'] = grammarEndings;
    data['band'] = band;
    data['title'] = title;
    data['body'] = body;
    data['micro_tip'] = microTip;
    data['words'] = words;
    return data;
  }
}
