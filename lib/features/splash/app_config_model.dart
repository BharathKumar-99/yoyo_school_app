class AppConfigModel {
  int? id;
  String? createdAt;
  String? appVersion;
  bool? isMaintainance;

  AppConfigModel({
    this.id,
    this.createdAt,
    this.appVersion,
    this.isMaintainance,
  });

  AppConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    appVersion = json['app_version'];
    isMaintainance = json['is_maintainance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['app_version'] = appVersion;
    data['is_maintainance'] = isMaintainance;
    return data;
  }
}
