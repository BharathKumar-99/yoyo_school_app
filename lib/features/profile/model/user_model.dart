import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/features/home/model/student_classes.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';
import 'package:yoyo_school_app/features/result/model/user_result_model.dart';

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
  List<Student>? studentList;
  Student? student;
  List<StudentClassesModel>? studentClasses;
  List<UserResult>? userResult;
  bool? isFeedBackRecorded;

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
    this.studentList,
    this.studentClasses,
    this.userResult,
    this.isFeedBackRecorded,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    createdAt = DateTime.tryParse(json['created_at'])!;
    firstName = json['first_name'];
    surName = json['sur_name'];
    email = json['email'];
    username = json['username'];

    isTester = json['is_tester'];
    isFeedBackRecorded = json['is_feedback_recorded'] ?? false;

    school = json['school'] != null && json['school'] is int
        ? json['school']
        : null;

    lastLogin = json['last_login'] != null
        ? DateTime.tryParse(json['last_login'])
        : null;
    studentClasses = (json['student_classes'] as List?)
        ?.map((e) => StudentClassesModel.fromJson(e))
        .toList();
    onboarding = json['onboarding'];

    if (json['student'] != null && json['student'] is List) {
      studentList = <Student>[];
      json['student'].forEach((v) {
        studentList!.add(Student.fromJson(v));
      });
    }
    if (json['student'] != null && json['student'] is Map) {
      student = Student.fromJson(json['student']);
    }
    if (json[DbTable.userResult] != null) {
      userResult = <UserResult>[];
      json[DbTable.userResult].forEach((v) {
        userResult!.add(UserResult.fromJson(v));
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
      'is_feedback_recorded': isFeedBackRecorded,
    };
  }
}
