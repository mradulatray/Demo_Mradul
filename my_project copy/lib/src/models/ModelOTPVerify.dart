class ModelOTPVerify {
  bool? success;
  Data? data;
  String? message;

  ModelOTPVerify({this.success, this.data, this.message});

  ModelOTPVerify.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  String? apiToken;
  String? deviceToken;

  String? createdAt;
  String? updatedAt;
  String? phone;
  bool? phoneVerified;
  bool? hasMedia;

  Data({
    this.id,
    this.name,
    this.email,
    this.apiToken,
    this.deviceToken,
    this.createdAt,
    this.updatedAt,
    this.phone,
    this.phoneVerified,
    this.hasMedia,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    apiToken = json['api_token'];
    deviceToken = json['device_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    phone = json['phone'];
    phoneVerified = json['phone_verified'];
    hasMedia = json['has_media'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['api_token'] = this.apiToken;
    data['device_token'] = this.deviceToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['phone'] = this.phone;
    data['phone_verified'] = this.phoneVerified;
    data['has_media'] = this.hasMedia;
    return data;
  }
}
