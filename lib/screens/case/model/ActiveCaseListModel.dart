class ActiveCaseListModel {
  int? statusCode;
  String? message;
  ActiveCaseListData? data;

  ActiveCaseListModel({this.statusCode, this.message, this.data});

  ActiveCaseListModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? new ActiveCaseListData.fromJson(json['data']) : null;
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

class ActiveCaseListData {
  int? totalPendingCase;
  int? totalAmount;
  List<Visit>? visit;

  ActiveCaseListData({this.totalPendingCase, this.totalAmount, this.visit});

  ActiveCaseListData.fromJson(Map<String, dynamic> json) {
    totalPendingCase = json['total_pending_case'];
    totalAmount = json['total_amount'];
    if (json['visit'] != null) {
      visit = <Visit>[];
      json['visit'].forEach((v) {
        visit!.add(new Visit.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_pending_case'] = this.totalPendingCase;
    data['total_amount'] = this.totalAmount;
    if (this.visit != null) {
      data['visit'] = this.visit!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Visit {
  int? id;
  String? patientId;
  String? visitDate;
  String? followupDate;
  String? vaidId;
  String? city;
  String? caseAmount;
  String? paidStatus;
  String? paidDate;
  String? followOfStatus;
  String? createdAt;
  String? updatedAt;
  Patient? patient;

  Visit(
      {this.id,
        this.patientId,
        this.visitDate,
        this.followupDate,
        this.vaidId,
        this.city,
        this.caseAmount,
        this.paidStatus,
        this.paidDate,
        this.followOfStatus,
        this.createdAt,
        this.updatedAt,
        this.patient});

  Visit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'].toString();
    visitDate = json['visit_date'].toString();
    followupDate = json['followup_date'].toString();
    vaidId = json['vaid_id'].toString();
    city = json['city'].toString();
    caseAmount = json['case_amount'].toString();
    paidStatus = json['paid_status'].toString();
    paidDate = json['paid_date'].toString();
    followOfStatus = json['follow_of_status'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    patient =
    json['patient'] != null ? new Patient.fromJson(json['patient']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['visit_date'] = this.visitDate;
    data['followup_date'] = this.followupDate;
    data['vaid_id'] = this.vaidId;
    data['city'] = this.city;
    data['case_amount'] = this.caseAmount;
    data['paid_status'] = this.paidStatus;
    data['paid_date'] = this.paidDate;
    data['follow_of_status'] = this.followOfStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.patient != null) {
      data['patient'] = this.patient!.toJson();
    }
    return data;
  }
}

class Patient {
  int? id;
  String? padvi;
  String? name;
  String? age;
  String? sevak;
  String? mobileNo;
  String? samudai;
  String? location;
  String? createdAt;
  String? updatedAt;

  Patient(
      {this.id,
        this.padvi,
        this.name,
        this.age,
        this.sevak,
        this.mobileNo,
        this.samudai,
        this.location,
        this.createdAt,
        this.updatedAt});

  Patient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    padvi = json['padvi'].toString();
    name = json['name'].toString();
    age = json['age'].toString();
    sevak = json['sevak'].toString();
    mobileNo = json['mobile_no'].toString();
    samudai = json['samudai'].toString();
    location = json['location'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['padvi'] = this.padvi;
    data['name'] = this.name;
    data['age'] = this.age;
    data['sevak'] = this.sevak;
    data['mobile_no'] = this.mobileNo;
    data['samudai'] = this.samudai;
    data['location'] = this.location;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
