class MsgModel {
  int? statusCode;
  String? message;

  MsgModel({this.statusCode, this.message});

  MsgModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_code'] = statusCode;
    data['message'] = message;
    return data;
  }
}
