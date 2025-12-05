class UserModel {
  String userId;
  DateTime createdAt;
  String? firstName;
  String? surName;
  String? email;
  int? school;
  String? username;
  DateTime? lastLogin;
  bool? onboarding;
  bool? isTester;

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
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      firstName: json['first_name'] as String?,
      surName: json['sur_name'] as String?,
      email: json['email'] as String?,
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'])
          : null,
      username: json['username'] as String?,
      onboarding: json['onboarding'],
      isTester: json['is_tester'],
      school: json['school'] is int
          ? json['school'] as int
          : int.tryParse(json['school']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
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
