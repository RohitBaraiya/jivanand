import 'dart:async';
import 'dart:convert';
import 'package:jivanand/db/model/CartModel.dart';
import 'package:jivanand/main.dart';
import 'package:jivanand/model/ConfigModel.dart';
import 'package:jivanand/model/MsgModel.dart';
import 'package:jivanand/network/network_utils.dart';
import 'package:jivanand/screens/case/model/ActiveCaseListModel.dart';
import 'package:jivanand/screens/case/model/CaseListModel.dart';
import 'package:jivanand/screens/patients/model/PatientsListModel.dart';
import 'package:jivanand/screens/patients/model/VisitListMode.dart';
import 'package:jivanand/screens/vaid/model/VaidListModel.dart';
import 'package:jivanand/utils/common.dart';
import 'package:jivanand/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';


Future<ConfigModel> getConfig({required String key}) async {
  try {
    Map<String, dynamic> req = {
      'time_range': key.isNotEmpty ? key : '',
    };
    ConfigModel res = ConfigModel.fromJson(await handleResponse(await buildHttpResponse(urlType: 'my',request: req,'total_pending_list',/* request: req,*/ method: HttpMethodType.POST)));
    return res;
  } catch (e) {
    appStore.setLoading(false);
    log('eeee${e.toString()}');
    rethrow;
  }
}


const int perPageCat=20;
Future<List<PatientsListData>> getPatientsWithPagination(int page,
    {
      required String search,
      var perPage = perPageCat,
      required List<PatientsListData> categoryList,
      Function(bool)? lastPageCallBack}) async {
  try {
    Map<String, dynamic> req = {
      'search': search.isNotEmpty ? search : '',
      'page': page.toString() ,
      'limit': perPageCat.toString() ,
    };

    PatientsListModel res = PatientsListModel.fromJson(await handleResponse(await buildHttpResponse(urlType: 'my', 'list_patients',request: req, method: HttpMethodType.POST)));
    //log('lastpage ${res.offset.toString()}');

    lastPageCallBack?.call(res.data.validate().length != perPage);

    if (page == 1) categoryList.clear();
    categoryList.addAll(res.data.validate());
    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    rethrow;
  }
  return categoryList;
}



Future<MsgModel> addPatient({required PatientsListData model,}) async {
  try {
    String date = formatDate(DateTime.now().toString(), format: DATE_FORMAT_7);
    Map<String, dynamic> req = {
      'padvi': model.padvi.validate().isNotEmpty ? model.padvi.validate() : '',
      'name': model.name.validate().isNotEmpty ? model.name.validate() : '',
      'age': model.age.validate().toString(),
      'samudai': model.samudai.validate().isNotEmpty ? model.samudai.validate() : '',
      'sevak': model.sevak.validate().isNotEmpty ? model.sevak.validate() : '',
      'mobile_no': model.mobileNo.validate().isNotEmpty ? model.mobileNo.validate() : '',
      'location': model.location.validate().isNotEmpty ? model.location.validate() : '',
    };
    MsgModel res = MsgModel.fromJson(await handleResponse(await buildHttpResponse(urlType: 'my', 'add_patient',request: req, method: HttpMethodType.POST)));
    return res;
  } catch (e) {
    rethrow;
  }
}


Future<MsgModel> addCase({required String id,required String vaidId, required String cityName, required String caseAmount, required String followupDate,}) async {
  try {

    Map<String, dynamic> req = {
      'patient_id': id.isNotEmpty ? id : '',
      'vaid_id': vaidId.isNotEmpty ? vaidId : '',
      'city': cityName.isNotEmpty ? cityName : '',
      'case_amount': caseAmount.isNotEmpty ? caseAmount : '',
      'followup_date': followupDate.isNotEmpty ? followupDate : '',
    };
    MsgModel res = MsgModel.fromJson(await handleResponse(await buildHttpResponse(urlType: 'my', 'add_case',request: req, method: HttpMethodType.POST)));
    return res;
  } catch (e) {
    rethrow;
  }
}


Future<PatientsListData> getPatientDetail({required String pId,}) async {
  try {
    Map<String, dynamic> req = {
      'patient_id': pId.isNotEmpty ? pId : '',
    };

    PatientsListModel res = PatientsListModel.fromJson(await handleResponse(await buildHttpResponse(urlType: 'my', 'patient_detail',request: req, method: HttpMethodType.POST)));
    return res.data.validate().first;
  } catch (e) {
    rethrow;
  }
}







Future<List<CaseData>> getCaseWithPagination(int page,
    {
      required String searchDate,
      required String search,
      var perPage = perPageCat,
      required List<CaseData> categoryList,
      Function(bool)? lastPageCallBack}) async {
  try {
  //  String date = formatBookingDate(DateTime.now().toString(),format: DATE_FORMAT_7,);
    Map<String, dynamic> req = {
      'search': search.isNotEmpty ? search : '',
      'page': page.toString() ,
      'start_date': searchDate ,
      'end_date': searchDate,
      'limit': perPageCat.toString() ,
    };

    CaseListModel res = CaseListModel.fromJson(await handleResponse(await buildHttpResponse(urlType: 'my', 'case_list',request: req, method: HttpMethodType.POST)));
    //log('lastpage ${res.offset.toString()}');

    lastPageCallBack?.call(res.data.validate().length != perPage);

    if (page == 1) categoryList.clear();
    categoryList.addAll(res.data.validate());
    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    rethrow;
  }
  return categoryList;
}


Future<List<VaidListData>> getVaidListWithPagination(int page,
    {
      required String search,
      var perPage = perPageCat,
      required List<VaidListData> categoryList,
      Function(bool)? lastPageCallBack}) async {
  try {
    String date = formatBookingDate(DateTime.now().toString(),format: DATE_FORMAT_7,);
    Map<String, dynamic> req = {
      'search': search.isNotEmpty ? search : '',
      'page': page.toString() ,
      'start_date': date ,
      'end_date': date,
      'limit': perPageCat.toString() ,
    };

    VaidListModel res = VaidListModel.fromJson(await handleResponse(await buildHttpResponse(urlType: 'my', 'list_vaid',request: req, method: HttpMethodType.POST)));
    //log('lastpage ${res.offset.toString()}');

    lastPageCallBack?.call(res.data.validate().length != perPage);

    if (page == 1) categoryList.clear();
    categoryList.addAll(res.data.validate());
    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    rethrow;
  }
  return categoryList;
}


Future<MsgModel> addVaid({required VaidListData model,}) async {
  try {
    String date = formatDate(DateTime.now().toString(), format: DATE_FORMAT_7);

    Map<String, dynamic> req = {
      'name': model.name.validate().isNotEmpty ? model.name.validate() : '',
      'mobile_no': model.mobileNo.validate().isNotEmpty ? model.mobileNo.validate() : '',
      'email': model.email.validate().isNotEmpty ? model.email.validate() : '',
      'gender': model.gender.validate().isNotEmpty ? model.gender.validate() : '',
      'address': model.address.validate().isNotEmpty ? model.address.validate() : '',
      'pin_code': model.pinCode.validate().isNotEmpty ? model.pinCode.validate() : '',
    };
    MsgModel res = MsgModel.fromJson(await handleResponse(await buildHttpResponse(urlType: 'my', 'add_vaid',request: req, method: HttpMethodType.POST)));
    return res;
  } catch (e) {
    rethrow;
  }
}


Future<MsgModel> deleteVaid({required String id,}) async {
  try {

    Map<String, dynamic> req = {
      'vaid_id': id.isNotEmpty ? id : '',
    };
    MsgModel res = MsgModel.fromJson(await handleResponse(await buildHttpResponse(urlType: 'my', 'delete_vaid',request: req, method: HttpMethodType.POST)));
    return res;
  } catch (e) {
    rethrow;
  }
}




Future<VaidListModel> getAllVaidList() async {
  try {
    VaidListModel res = VaidListModel.fromJson(await handleResponse(await buildHttpResponse(urlType: 'my', 'total_vaid_list', method: HttpMethodType.GET)));
    return res;
  } catch (e) {
    appStore.setLoading(false);
    rethrow;
  }
}




Future<VisitListMode> getPatientVisit({required String pId,}) async {
  try {
    Map<String, dynamic> req = {
      'patient_id': pId.isNotEmpty ? pId : '',
    };

    VisitListMode res = VisitListMode.fromJson(await handleResponse(await buildHttpResponse(urlType: 'my', 'visit_list',request: req, method: HttpMethodType.POST)));
    return res;
  } catch (e) {
    rethrow;
  }
}






Future<ActiveCaseListModel> getActiveCaseWithPagination(int page,
    {
      required String status,
      required String search,
      var perPage = perPageCat,
      // required List<CaseData> categoryList,
      Function(bool)? lastPageCallBack}) async {
  try {
    //  String date = formatBookingDate(DateTime.now().toString(),format: DATE_FORMAT_7,);
    Map<String, dynamic> req = {
      'search': search.isNotEmpty ? search : '',
      'page': page.toString() ,
      'status': status.isNotEmpty ? status : '' ,
      'limit': perPageCat.toString() ,
    };

    ActiveCaseListModel res = ActiveCaseListModel.fromJson(await handleResponse(await buildHttpResponse(urlType: 'my', 'get_case_by_status',request: req, method: HttpMethodType.POST)));
    //log('lastpage ${res.offset.toString()}');

    // lastPageCallBack?.call(res.data!.cases.validate().length != perPage);

    // if (page == 1) categoryList.clear();
    // categoryList.addAll(res.data!.cases.validate());
    appStore.setLoading(false);
    return res;
  } catch (e) {
    appStore.setLoading(false);
    rethrow;
  }
}


Future<MsgModel> dischargeCase({
  required String id,
  required String paidDate,
  required String caseAmount,
}) async {
  try {

    Map<String, dynamic> req = {
      'id': id.isNotEmpty ? id : '',
      'paid_date': paidDate.isNotEmpty ? paidDate : '',
      'case_amount': caseAmount.isNotEmpty ? caseAmount : '',
      'paid_status': '1',
    };
    MsgModel res = MsgModel.fromJson(await handleResponse(await buildHttpResponse(urlType: 'my', 'edit_case',request: req, method: HttpMethodType.POST)));
    return res;
  } catch (e) {
    rethrow;
  }
}











