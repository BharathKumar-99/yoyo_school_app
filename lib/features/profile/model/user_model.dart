import 'package:yoyo_school_app/features/home/model/student_classes.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';

class UserModel {
  String? userId;
  DateTime? createdAt;
  String? firstName;
  String? surName;
  String? email;
  int? school;
  String? username;
  DateTime? lastLogin;
  bool? onboarding;
  bool? isTester;
  List<Student>? student;
  List<StudentClassesModel>? studentClasses;

  UserModel({
    required this.userId,
    required this.createdAt,
    this.email,
    this.school,
    this.firstName,
    this.surName,
    this.username,
    this.lastLogin,
    this.onboarding,
    this.isTester,
    this.student,
    this.studentClasses,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    createdAt = DateTime.tryParse(json['created_at'])!;
    firstName = json['first_name'];
    surName = json['sur_name'];
    email = json['email'];
    username = json['username'];

    isTester = json['is_tester'];

    school = json['school'] != null && json['school'] is int
        ? json['school']
        : null;

    lastLogin = json['last_login'] != null
        ? DateTime.tryParse(json['last_login'])
        : null;
    studentClasses = (json['student_classes'] as List?)
        ?.map((e) => StudentClassesModel.fromJson(e))
        .toList();
    onboarding =
        json['onboarding']; // FIXED: This field was missing in previous versions, causing infinite onboarding loop.

    if (json['student'] != null) {
      student = <Student>[];
      json['student'].forEach((v) {
        student!.add(Student.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'created_at': createdAt?.toIso8601String(),
      'email': email,
      'school': school,
      'first_name': firstName,
      'sur_name': surName,
      'last_login': lastLogin?.toIso8601String(),
      'onboarding': onboarding,
      'is_tester': isTester,
    };
  }
}
