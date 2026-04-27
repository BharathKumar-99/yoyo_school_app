import 'package:yoyo_school_app/features/home/model/phrases_model.dart';

class PhraseCategoriesModel {
  int? id;
  String? createdAt;
  String? name;
  String? image;
  int? language;
  List<PhraseModel>? phrases;

  PhraseCategoriesModel({
    this.id,
    this.createdAt,
    this.name,
    this.image,
    this.language,
    this.phrases,
  });

  PhraseCategoriesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    name = json['name'];
    language = json['language'];
    image = json['image'];
    if (json['phrase'] != null) {
      phrases = <PhraseModel>[];
      json['phrase'].forEach((v) {
        phrases!.add(PhraseModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['name'] = name;
    data['language'] = language;
    data['images'] = image;
    data['phrase'] = phrases;
    return data;
  }
}
