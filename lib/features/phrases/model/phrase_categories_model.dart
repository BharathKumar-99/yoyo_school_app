class PhraseCategoriesModel {
  int? id;
  String? createdAt;
  String? name;
  String? image;
  int? language;

  PhraseCategoriesModel({
    this.id,
    this.createdAt,
    this.name,
    this.image,
    this.language,
  });

  PhraseCategoriesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    name = json['name'];
    language = json['language'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['name'] = name;
    data['language'] = language;
    data['images'] = image;
    return data;
  }
}
