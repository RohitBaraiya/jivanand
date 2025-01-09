class ConfigModel {
  int? statusCode;
  String? message;
  ConfigData? data;

  ConfigModel({this.statusCode, this.message, this.data});

  ConfigModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? new ConfigData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ConfigData {
  int? totalPendingCase;
  int? totalAmount;

  ConfigData({this.totalPendingCase, this.totalAmount});

  ConfigData.fromJson(Map<String, dynamic> json) {
    totalPendingCase = json['total_pending_case'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_pending_case'] = this.totalPendingCase;
    data['total_amount'] = this.totalAmount;
    return data;
  }
}
