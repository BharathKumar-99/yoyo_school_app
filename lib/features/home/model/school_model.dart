import 'package:yoyo_school_app/features/home/model/classes_model.dart';

import '../../../config/constants/constants.dart';

class School {
  int? id;
  String? principle;
  DateTime? createdAt;
  String? schoolName;
  int? noOfStudents;
  String? schoolAddress;
  int? schoolTelephoneNo;
  String? image;
  List<Classes>? classes;

  School({
    this.id,
    this.principle,
    this.createdAt,
    this.schoolName,
    this.noOfStudents,
    this.schoolAddress,
    this.schoolTelephoneNo,
    this.image,
    this.classes,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'],
      principle: json['principle'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      schoolName: json['school_name'],
      noOfStudents: json['no_of_students'],
      schoolAddress: json['school_address'],

      schoolTelephoneNo: json['school_telephone_no'],
      image: json['image'],
      classes: (json[DbTable.classes] as List?)
          ?.map((e) => Classes.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'principle': principle,
      'created_at': createdAt?.toIso8601String(),
      'school_name': schoolName,
      'no_of_students': noOfStudents,
      'school_address': schoolAddress,
      'school_telephone_no': schoolTelephoneNo,
      'image': image,
    };
  }
}
