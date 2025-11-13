class RemoteConfig {
  final int id;
  final DateTime createdAt;
  final String apiKey;
  final String apiSecretKey;
  final bool streak;
  final num frSlack;
  final LanguageSlack slack;

  const RemoteConfig({
    required this.id,
    required this.createdAt,
    required this.apiKey,
    required this.apiSecretKey,
    required this.streak,
    required this.frSlack,
    required this.slack,
  });

  factory RemoteConfig.fromJson(Map<String, dynamic> json) {
    final createdAtValue = json['created_at'];
    DateTime parsedCreatedAt;
    if (createdAtValue is String) {
      parsedCreatedAt = DateTime.parse(createdAtValue);
    } else if (createdAtValue is DateTime) {
      parsedCreatedAt = createdAtValue;
    } else {
      parsedCreatedAt = DateTime.fromMillisecondsSinceEpoch(0);
    }

    return RemoteConfig(
      id: json['id'] is int ? json['id'] as int : int.parse('${json['id']}'),
      createdAt: parsedCreatedAt,
      apiKey: json['api_key'] as String,
      apiSecretKey: json['api_secret_key'] as String,
      streak: json['streak'] as bool,
      frSlack: json['fr_slack'] as num,
      slack: LanguageSlack.fromJson(json['language_slack']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'created_at': createdAt.toUtc().toIso8601String(),
    'api_key': apiKey,
    'api_secret_key': apiSecretKey,
    'streak': streak,
    'fr_slack': frSlack,
    'language_slack': slack.toJson(),
  };
}

class LanguageSlack {
  final int de;
  final int fr;
  final int jp;
  final int kr;
  final int ru;
  final int sp;
  final int promax;
  final int promaxCn;

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
