class VisitListMode {
  int? statusCode;
  String? message;
  List<VisitListData>? data;

  VisitListMode({this.statusCode, this.message, this.data});

  VisitListMode.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <VisitListData>[];
      json['data'].forEach((v) {
        data!.add(new VisitListData.fromJson(v));
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

class VisitListData {
  String? vaidName;
  String? city;
  String? visitDate;

  VisitListData({
    this.vaidName,
    this.city,
    this.visitDate});

  VisitListData.fromJson(Map<String, dynamic> json) {
    vaidName = json['vaid_name'];
    city = json['city'];
    visitDate = json['visit_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vaid_naame'] = this.vaidName;
    data['city'] = this.city;
    data['visit_date'] = this.visitDate;
    return data;
  }
}
