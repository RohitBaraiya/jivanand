class VaidListModel {
  int? statusCode;
  String? message;
  List<VaidListData>? data;

  VaidListModel({this.statusCode, this.message, this.data});

  VaidListModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <VaidListData>[];
      json['data'].forEach((v) {
        data!.add(new VaidListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VaidListData {
  int? id;
  String? name;
  String? mobileNo;
  String? gender;
  String? address;
  String? email;
  String? pinCode;
  String? status;
  String? createdAt;
  String? updatedAt;

  VaidListData(
      {this.id,
        this.name,
        this.mobileNo,
        this.gender,
        this.address,
        this.email,
        this.pinCode,
        this.status,
        this.createdAt,
        this.updatedAt});

  VaidListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobileNo = json['mobile_no'];
    gender = json['gender'];
    address = json['address'];
    email = json['email'];
    pinCode = json['pin_code'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mobile_no'] = this.mobileNo;
    data['gender'] = this.gender;
    data['address'] = this.address;
    data['email'] = this.email;
    data['pin_code'] = this.pinCode;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
