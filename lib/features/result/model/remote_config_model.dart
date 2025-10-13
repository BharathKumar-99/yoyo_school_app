class RemoteConfig {
  final int id;
  final DateTime createdAt;
  final String apiKey;
  final String apiSecretKey;

  const RemoteConfig({
    required this.id,
    required this.createdAt,
    required this.apiKey,
    required this.apiSecretKey,
  });

  factory RemoteConfig.fromJson(Map<String, dynamic> json) {
    final createdAtValue = json['created_at'];
    DateTime parsedCreatedAt;
    if (createdAtValue is String) {
      parsedCreatedAt = DateTime.parse(createdAtValue);
    } else if (createdAtValue is DateTime) {
      parsedCreatedAt = createdAtValue;
    } else {
      // fallback: treat null/unknown as epoch (you can change behavior)
      parsedCreatedAt = DateTime.fromMillisecondsSinceEpoch(0);
    }

    return RemoteConfig(
      id: json['id'] is int ? json['id'] as int : int.parse('${json['id']}'),
      createdAt: parsedCreatedAt,
      apiKey: json['api_key'] as String,
      apiSecretKey: json['api_secret_key'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'created_at': createdAt.toUtc().toIso8601String(),
    'api_key': apiKey,
    'api_secret_key': apiSecretKey,
  };
}
