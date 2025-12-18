class RemoteConfig {
  final int id;
  final DateTime createdAt;
  final String apiKey;
  final String apiSecretKey;
  final bool streak;
  final bool onboarding;
  final bool mastery;
  final bool warmup;
  LanguageSlack slack;
  int school;
  List<PhraseDisabledSchools> phraseDisabledSchools;

  RemoteConfig({
    required this.id,
    required this.createdAt,
    required this.apiKey,
    required this.apiSecretKey,
    required this.streak,
    required this.onboarding,
    required this.mastery,
    required this.slack,
    required this.school,
    required this.warmup,
    required this.phraseDisabledSchools,
  });

  factory RemoteConfig.fromJson(Map<String, dynamic> json) {
    final createdAtValue = json['created_at'];
    List<PhraseDisabledSchools> phraseDisabledSchool = [];
    DateTime parsedCreatedAt;
    if (createdAtValue is String) {
      parsedCreatedAt = DateTime.parse(createdAtValue);
    } else if (createdAtValue is DateTime) {
      parsedCreatedAt = createdAtValue;
    } else {
      parsedCreatedAt = DateTime.fromMillisecondsSinceEpoch(0);
    }
    if (json['phrase_disabled_schools'] != null) {
      json['phrase_disabled_schools'].forEach((v) {
        phraseDisabledSchool.add(PhraseDisabledSchools.fromJson(v));
      });
    }

    return RemoteConfig(
      id: json['id'] is int ? json['id'] as int : int.parse('${json['id']}'),
      createdAt: parsedCreatedAt,
      apiKey: json['api_key'] as String,
      apiSecretKey: json['api_secret_key'] as String,
      streak: json['streak'] as bool,
      onboarding: json['onboarding'] as bool,
      mastery: json['mastery'] as bool,
      slack: LanguageSlack.fromJson(json['language_slack']),
      school: json['school'],
      warmup: json['warmup'],
      phraseDisabledSchools: phraseDisabledSchool,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'created_at': createdAt.toUtc().toIso8601String(),
    'api_key': apiKey,
    'api_secret_key': apiSecretKey,
    'streak': streak,
    'onboarding': onboarding,
    'language_slack': slack.toJson(),
    'mastery': mastery,
    'school': school,
    'warmup': warmup,
  };
}

class LanguageSlack {
  num de;
  num fr;
  num jp;
  num kr;
  num ru;
  num sp;
  num promax;
  num promaxCn;

  LanguageSlack({
    required this.de,
    required this.fr,
    required this.jp,
    required this.kr,
    required this.ru,
    required this.sp,
    required this.promax,
    required this.promaxCn,
  });

  factory LanguageSlack.fromJson(Map<String, dynamic> json) {
    return LanguageSlack(
      de: json['de'] ?? 0,
      fr: json['fr'] ?? 0,
      jp: json['jp'] ?? 0,
      kr: json['kr'] ?? 0,
      ru: json['ru'] ?? 0,
      sp: json['sp'] ?? 0,
      promax: json['promax'] ?? 0,
      promaxCn: json['promax.cn'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'de': de,
      'fr': fr,
      'jp': jp,
      'kr': kr,
      'ru': ru,
      'sp': sp,
      'promax': promax,
      'promax.cn': promaxCn,
    };
  }
}

class PhraseDisabledSchools {
  int? id;
  int? phraseId;
  int? remoteId;
  String? disabledAt;

  PhraseDisabledSchools({
    this.id,
    this.phraseId,
    this.remoteId,
    this.disabledAt,
  });

  PhraseDisabledSchools.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phraseId = json['phrase_id'];
    remoteId = json['remote_id'];
    disabledAt = json['disabled_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phrase_id'] = phraseId;
    data['remote_id'] = remoteId;
    data['disabled_at'] = disabledAt;
    return data;
  }
}
