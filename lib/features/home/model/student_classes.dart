import 'dart:ffi';

import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/features/home/model/classes_model.dart';
import 'package:yoyo_school_app/features/profile/model/user_model.dart';

class StudentClassesModel {
  int? id;
  String? createdAt;
  String? userId;
  int? classId;
  UserModel? user;
  Classes? classes;

  StudentClassesModel({this.id, this.createdAt, this.user, this.classes});

  StudentClassesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    userId = json['user'] is String ? json['user'] : null;
    classId = json['classes'] is Int ? json['classes'] : null;
    user = json[DbTable.users] is Map
        ? UserModel.fromJson(json[DbTable.users])
        : null;
    classes = json[DbTable.classes] is Map
        ? Classes.fromJson(json[DbTable.classes])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['user'] = user;
    data['classes'] = classes;
    return data;
  }
}
