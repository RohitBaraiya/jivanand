class PatientsListModel {
  int? statusCode;
  String? message;
  List<PatientsListData>? data;

  PatientsListModel({this.statusCode, this.message, this.data});

  PatientsListModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PatientsListData>[];
      json['data'].forEach((v) {
        data!.add(new PatientsListData.fromJson(v));
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

class PatientsListData {
  int? id;
  String? padvi;
  String? name;
  int? age;
  String? sevak;
  String? mobileNo;
  String? samudai;
  String? location;
  String? createdAt;
  String? updatedAt;
  List<Files>? files;

  PatientsListData(
      {this.id,
        this.padvi,
        this.name,
        this.age,
        this.sevak,
        this.mobileNo,
        this.samudai,
        this.location,
        this.createdAt,
        this.updatedAt,
        this.files});

  PatientsListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    padvi = json['padvi'];
    name = json['name'];
    age = json['age'];
    sevak = json['sevak'];
    mobileNo = json['mobile_no'];
    samudai = json['samudai'];
    location = json['location'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(new Files.fromJson(v));
      });
    }
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
    if (this.files != null) {
      data['files'] = this.files!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Files {
  int? fileNumber;
  List<Images>? images;

  Files({this.fileNumber, this.images});

  Files.fromJson(Map<String, dynamic> json) {
    fileNumber = json['file_number'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file_number'] = this.fileNumber;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  int? id;
  int? pageNumber;
  String? image;

  Images({this.id, this.pageNumber, this.image});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pageNumber = json['page_number'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['page_number'] = this.pageNumber;
    data['image'] = this.image;
    return data;
  }
}
