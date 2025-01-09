class ConfigModel {
  int? statusCode;
  String? message;
  List<ColorList>? colorList;

  ConfigModel({this.statusCode, this.message, this.colorList});

  ConfigModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    message = json['message'];
    if (json['color_list'] != null) {
      colorList = <ColorList>[];
      json['color_list'].forEach((v) {
        colorList!.add(new ColorList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.colorList != null) {
      data['color_list'] = this.colorList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ColorList {
  int? id;
  String? colorName;

  ColorList({this.id, this.colorName,});

  ColorList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    colorName = json['color_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['color_name'] = this.colorName;
    return data;
  }
}
