class Fcm {
  String? fcmId;
  String? deviceId;

  Fcm({this.fcmId, this.deviceId});

  Fcm.fromJson(Map<String, dynamic> json) {
    fcmId = json['fcmId'];
    deviceId = json['deviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fcmId'] = fcmId;
    data['deviceId'] = deviceId;
    return data;
  }
}
