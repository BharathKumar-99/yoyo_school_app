import '../../../config/constants/constants.dart';
import 'language_model.dart';
import 'school_model.dart';
import 'student_classes.dart';

class Classes {
  int? id;
  School? school;
  String? className;
  DateTime? createdAt;
  int? noOfStudents;
  int? languageId;
  Language? language;
  int? submissionThreshold;
  List<StudentClassesModel>? studentClasses;
  bool? activationCodeTeacher;

  Classes({
    this.id,
    this.school,
    this.className,
    this.createdAt,
    this.noOfStudents,
    this.languageId,
    this.language,
    this.submissionThreshold,
    this.studentClasses,
    this.activationCodeTeacher,
  });

  factory Classes.fromJson(Map<String, dynamic> json) {
    return Classes(
      id: json['id'],
      school: json['school'] is Map ? School.fromJson(json['school']) : null,
      className: json['class_name'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      noOfStudents: json['no_of_students'],
      languageId: json['language'] is int ? json['language'] : null,
      language: json['language'] is Map
          ? Language.fromJson(json['language'])
          : null,
      submissionThreshold: json['submission_threshold'],
      activationCodeTeacher: json['activation_code_teacher'],
      studentClasses: (json[DbTable.studentClasses] as List?)
          ?.map((e) => StudentClassesModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'school': school?.toJson(),
      'class_name': className,
      'created_at': createdAt?.toIso8601String(),
      'no_of_students': noOfStudents,
      'submission_threshold': submissionThreshold,
      'activation_code_teacher': activationCodeTeacher,
    };
  }
}
