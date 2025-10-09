class Level {
  int? id;
  String? level;
  String? createdAt;

  Level({this.id, this.level, this.createdAt});

  Level.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    level = json['level'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['level'] = level;
    data['created_at'] = createdAt;
    return data;
  }
}
