class SuccessOrder {
  bool? success;
  Data? data;
  String? message;

  SuccessOrder({this.success, this.data, this.message});

  SuccessOrder.fromJson(Map<String, dynamic> json) {
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
  Data();

  Data.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    return data;
  }
}
