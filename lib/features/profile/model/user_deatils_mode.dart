class UserDetailsModel {
  final String? userId;
  final String? username;
  final String? email;
  final String? activationCode;
  final String? firstName;
  final String? surName;
  final int? classId;
  final String? className;
  final int? schoolId;
  final int? languageId;
  final String? languageName;
  final int? effort;
  final int? vocab;
  final int? score;
  final int? attempts;
  final int? completedAttempts;
  final String? started;
  final String? badgeName;
  final String? badgeImage;
  final String? badgeLevel;
  final int? schoolRank;
  final int? classRank;
  final int? rankClass;
  final int? homeWorkRank;
  final String? studentLanguage;

  UserDetailsModel({
    this.userId,
    this.username,
    this.email,
    this.activationCode,
    this.firstName,
    this.surName,
    this.classId,
    this.className,
    this.schoolId,
    this.languageId,
    this.languageName,
    this.effort,
    this.vocab,
    this.score,
    this.attempts,
    this.completedAttempts,
    this.started,
    this.badgeName,
    this.badgeImage,
    this.badgeLevel,
    this.schoolRank,
    this.classRank,
    this.rankClass,
    this.homeWorkRank,
    this.studentLanguage,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      userId: json['user_id']?.toString(),
      username: json['username']?.toString(),
      email: json['email']?.toString(),
      activationCode: json['activation_code']?.toString(),
      firstName: json['first_name']?.toString(),
      surName: json['sur_name']?.toString(),
      classId: json['class_id'],
      className: json['class_name']?.toString(),
      schoolId: json['school_id'],
      languageId: json['language_id'],
      languageName: json['language_name']?.toString(),
      effort: json['effort'],
      vocab: json['vocab'],
      score: json['score'],
      attempts: json['attempts'],
      completedAttempts: json['completed_attempts'],
      started: json['started']?.toString(),
      badgeName: json['badge_name']?.toString(),
      badgeImage: json['badge_image']?.toString(),
      badgeLevel: json['badge_level'],
      schoolRank: json['school_rank'],
      classRank: json['class_rank'],
      rankClass: json['rank_class'],
      homeWorkRank: json['home_work_rank'],
      studentLanguage: json['student_language']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'email': email,
      'activation_code': activationCode,
      'first_name': firstName,
      'sur_name': surName,
      'class_id': classId,
      'class_name': className,
      'school_id': schoolId,
      'language_id': languageId,
      'language_name': languageName,
      'effort': effort,
      'vocab': vocab,
      'score': score,
      'attempts': attempts,
      'completed_attempts': completedAttempts,
      'started': started,
      'badge_name': badgeName,
      'badge_image': badgeImage,
      'badge_level': badgeLevel,
      'school_rank': schoolRank,
      'class_rank': classRank,
      'rank_class': rankClass,
      'home_work_rank': homeWorkRank,
      'student_language': studentLanguage,
    };
  }

  static List<UserDetailsModel> listFromJson(List<dynamic>? list) {
    if (list == null) return [];
    return list.map((e) => UserDetailsModel.fromJson(e)).toList();
  }
}