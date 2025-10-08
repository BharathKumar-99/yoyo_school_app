import 'school_model.dart';

class Classes {
  int? id;
  School? school;
  String? className;
  DateTime? createdAt;
  int? noOfStudents;
  int? submissionThreshold;

  Classes({
    this.id,
    this.school,
    this.className,
    this.createdAt,
    this.noOfStudents,
    this.submissionThreshold,
  });

  factory Classes.fromJson(Map<String, dynamic> json) {
    return Classes(
      id: json['id'],
      school: json['school'] != null ? School.fromJson(json['school']) : null,
      className: json['class_name'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      noOfStudents: json['no_of_students'],
      submissionThreshold: json['submission_threshold'],
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
    };
  }
}
