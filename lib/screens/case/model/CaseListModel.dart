class CaseListModel {
  int? statusCode;
  String? message;
  int? totalVisits;
  List<CaseData>? data;

  CaseListModel({this.statusCode, this.message, this.totalVisits, this.data});

  CaseListModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    message = json['message'];
    totalVisits = json['total_visits'];
    if (json['data'] != null) {
      data = <CaseData>[];
      json['data'].forEach((v) {
        data!.add(new CaseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    data['total_visits'] = this.totalVisits;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CaseData {

  int? id;
  int? patientId;
  String? visitDate;
  String? followUpDate;
  int? caseAmount;
  String? followOfStatus;
  String? city;
  PatientDetails? patientDetails;

  CaseData({this.id,
    this.patientId,
    this.visitDate,
    this.followUpDate,
    this.caseAmount,
    this.followOfStatus,
    this.city,
    this.patientDetails});

  CaseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    visitDate = json['visit_date'];
    followUpDate = json['follow_up_date'];
    caseAmount = json['case_amount'];
    followOfStatus = json['follow_of_status'];
    city = json['city'];
    patientDetails = json['patient_details'] != null
        ? new PatientDetails.fromJson(json['patient_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['visit_date'] = this.visitDate;
    data['follow_up_date'] = this.followUpDate;
    data['case_amount'] = this.caseAmount;
    data['follow_of_status'] = this.followOfStatus;
    data['city'] = this.city;
    if (this.patientDetails != null) {
      data['patient_details'] = this.patientDetails!.toJson();
    }
    return data;
  }
}

class PatientDetails {
  int? id;
  String? name;
  String? padvi;
  int? age;
  String? sevak;
  String? mobileNo;
  String? samudai;

  PatientDetails(
      {this.id,
        this.name,
        this.padvi,
        this.age,
        this.sevak,
        this.mobileNo,
        this.samudai});

  PatientDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    padvi = json['padvi'];
    age = json['age'];
    sevak = json['sevak'];
    mobileNo = json['mobile_no'];
    samudai = json['samudai'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['padvi'] = this.padvi;
    data['age'] = this.age;
    data['sevak'] = this.sevak;
    data['mobile_no'] = this.mobileNo;
    data['samudai'] = this.samudai;
    return data;
  }
}
