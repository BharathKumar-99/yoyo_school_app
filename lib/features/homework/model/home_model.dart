import '../../home/model/phrases_model.dart';

class HomeworkModel {
  final int? id;
  final DateTime? createdAt;
  final String? title;
  final DateTime? setDate;
  final DateTime? dueDate;
  final bool? repeat;
  final int? school;
  final List<PhraseModel>? phrases;

  HomeworkModel({
    this.id,
    this.createdAt,
    this.title,
    this.setDate,
    this.dueDate,
    this.repeat,
    this.school,
    this.phrases,
  });

  factory HomeworkModel.fromJson(Map<String, dynamic> json) {
    return HomeworkModel(
      id: json['id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      title: json['title'],
      setDate: json['set_date'] != null
          ? DateTime.parse(json['set_date'])
          : null,
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'])
          : null,
      repeat: json['repeat'],
      school: json['school'],
      phrases: (json['phrase'] as List<dynamic>?)
          ?.map((e) => PhraseModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'title': title,
      'set_date': setDate?.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'repeat': repeat,
      'school': school,
      'phrase': phrases?.map((e) => e.toJson()).toList(),
    };
  }
}
