class UserModel {
  String userId;
  DateTime createdAt;
  String? firstName;
  String? surName;
  String? email;
  int? school;
  String? image;
  DateTime? lastLogin;

  UserModel({
    required this.userId,
    required this.createdAt,
    this.firstName,
    this.surName,
    this.email,
    this.school,
    this.image,
    this.lastLogin,
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
      image: json['image'] as String?,
      school: json['school'] is int
          ? json['school'] as int
          : int.tryParse(json['school']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'first_name': firstName,
      'sur_name': surName,
      'email': email,
      'school': school,
      'image': image,
      'last_login': lastLogin?.toIso8601String(),
    };
  }
}
