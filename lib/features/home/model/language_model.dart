import 'package:flutter/material.dart';

import 'phrases_model.dart';

class Language {
  int? id;
  String? image;
  int? level;
  List<Color>? gradient;
  String? language;
  List<PhraseModel>? phrase;
  DateTime? createdAt;

  Language({
    this.id,
    this.image,
    this.level,
    this.gradient,
    this.language,
    this.phrase,
    this.createdAt,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'] as int?,
      image: json['image'] as String?,
      level: json['level'] as int?,
      gradient:
          (json['gradient'] as List<dynamic>?)
              ?.map((e) => Color(int.tryParse(e.toString()) ?? 0xFFFFFFFF))
              .toList() ??
          [],
      phrase: (json['phrase'] as List?)
          ?.map((e) => PhraseModel.fromJson(e))
          .toList(),
      language: json['language'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'level': level,
      'phrase': phrase?.map((p) => p.toJson()).toList(),
      'gradient': gradient?.map((c) => c).toList(),
      'language': language,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
