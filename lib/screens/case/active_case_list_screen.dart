import 'package:jivanand/app_theme.dart';
import 'package:jivanand/component/base_scaffold_widget.dart';
import 'package:jivanand/component/empty_error_state_widget.dart';
import 'package:jivanand/generated/assets.dart';
import 'package:jivanand/main.dart';
import 'package:jivanand/network/rest_apis.dart';
import 'package:jivanand/screens/case/componet/active_case_list_widget.dart';
import 'package:jivanand/screens/case/componet/case_list_widget.dart';
import 'package:jivanand/screens/case/model/ActiveCaseListModel.dart';
import 'package:jivanand/screens/patients/add_patients_screen.dart';
import 'package:jivanand/screens/patients/model/PatientsListModel.dart';
import 'package:jivanand/screens/patients/patient_detail_screen.dart';
import 'package:jivanand/utils/common.dart';
import 'package:jivanand/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:jivanand/utils/string_extensions.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/colors.dart';
import 'dart:async';

import 'model/CaseListModel.dart';


class ActiveCaseListScreen extends StatefulWidget {
  final String? titleName;
  final String? staus;
  const ActiveCaseListScreen({super.key, this.staus='0', required this.titleName,});

  @override
  _CatListScreenState createState() => _CatListScreenState();
}

class _CatListScreenState extends State<ActiveCaseListScreen> with  SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    setStatusColor();
    init();
  }

  void init() async {
    page = 1;
    serviceList = [];
    _getProduct();
  }

  int page = 1;
  bool isLastPage = false;
  List<Visit> serviceList = [];
  Timer? _debounce;

  int? totalApprovedAmount=0;
  int? totalCase=0;

  void _getProduct() async {
    appStore.setLoading(true);
    await getActiveCaseWithPagination(page,
      status:  widget.staus.validate().toString().trim(),
      //categoryList: serviceList,
      search: nameCont.text.validate().toString().trim(),
      lastPageCallBack: (lastPage) {
        isLastPage = lastPage;
      },

    ).then((value) {
      if (page == 1) serviceList.clear();
      if(value.statusCode == 200){
        totalApprovedAmount = value.data!.totalAmount.validate();
        totalCase = value.data!.totalPendingCase.validate();

        if(value.data!.visit.validate().isNotEmpty){
          serviceList.addAll(value.data!.visit.validate());
        }/*else{
          serviceList =[];
        }*/
      }else{
        serviceList =[];
      }


      isLoading = false;
      if (_scrollController.hasClients && page !=1) {
        _scrollController.jumpTo(_scrollController.position.pixels + 80);
      }
      setState(() {},);
    },).catchError((e) async {
      toast(e.toString());
      log('catchError ${e.toString()}');
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    nameCont.dispose();
    nameFocus.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  TextEditingController nameCont = TextEditingController();
  FocusNode nameFocus = FocusNode();

  bool isLoading=false;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: widget.titleName.validate(),
      scaffoldBackgroundColor: bgColor,
      actions: [
        /*TextButton(
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            backgroundColor: context.primaryColor,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text("${formatBookingDate(selectedDate.toString(), format: DATE_FORMAT_32)}", style: boldTextStyle(color: white,size: 12)),
          onPressed: () {
            selectDate(context);
          },
        ).paddingRight(10)*/
      ],
      child: Column(
        children: [
          AnimatedScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
           // listAnimationType: ListAnimationType.FadeIn,
           // fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
            onSwipeRefresh: () async {
              // appStore.setLoading(true);
              init();
              setState(() {});
              return await 2.seconds.delay;
            },
            onNextPage: () async {
             // log('next$isLastPage');
                if (!isLastPage) {
                  isLoading=true;
                  setState(() {});
                  page++;
                  log("page: $page");
                  _getProduct();
                }
            },
            children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 AppTextField(
                   textFieldType: TextFieldType.NAME,
                   controller: nameCont,
                   focus: nameFocus,
                   errorThisFieldRequired: language.requiredText,
                   decoration: inputDecoration(context, labelText: 'Patient Name'),
                   /*onChanged: (str) async {
                     if (_debounce?.isActive ?? false) _debounce?.cancel();  // Cancel previous timer

                     _debounce = Timer(const Duration(milliseconds: 2000), () async {
                       if (str.isNotEmpty) {
                         page = 1;
                         _getProduct();
                         setState(() {});
                       }
                     });
                   },*/
                   suffix: CloseButton(
                     color: black,
                     onPressed: () {
                       page = 1;
                       nameCont.clear();
                       serviceList = [];
                       page = 1;
                       _getProduct();
                     },
                   ).visible(nameCont.text.isNotEmpty),  // Show the close button only when the text is not empty
                   onFieldSubmitted: (s) async {
                     page = 1;
                     serviceList = [];
                     _getProduct();
                   },
                 ).expand(),
                 10.width,
                 GestureDetector(
                   onTap: () {
                     page = 1;
                     serviceList = [];
                     _getProduct();
                   },
                   child: Container(
                     decoration: BoxDecoration(
                         color: cardColor1,
                          borderRadius: radius(12),
                         shape: BoxShape.rectangle,
                     ),
                     child: Assets.dresoulSearch.iconImage(size: 22,color: white).paddingAll(10),
                   ),
                 ),
               ],
             ).paddingSymmetric(vertical: 10,horizontal: 10),


              Column(
                  children: [
                    5.height,
                    Card(
                    color: newCardColor1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        Row(
                            children: [
                              Card(
                                color: newCardColor2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                margin: EdgeInsets.zero,
                                child: Column(
                                    children: [
                                      Text('${totalCase.validate().toString().capitalizeEachWord()}',style: boldTextStyle(size: 14, color: orderCancel),),
                                      2.height,
                                      Text('Total Cases',style: primaryTextStyle(size: 14, color: orderCancel),),
                                    ]).paddingAll(10),

                              ).paddingSymmetric(horizontal: 5,vertical: 5).expand(),
                              Card(
                                color: newCardColor2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                margin: EdgeInsets.zero,
                                child: Column(
                                    children: [
                                      Text('₹ ${totalApprovedAmount.validate().toString().capitalizeEachWord()} /-',style: boldTextStyle(size: 14, color: approw),),
                                      2.height,
                                      Text('Total Amount',style: primaryTextStyle(size: 14, color: approw),),
                                    ]).paddingAll(10),

                              ).paddingSymmetric(horizontal: 5,vertical: 5).expand(),

                            ]),
                      ],
                    ).paddingAll(5),

                                  ).paddingSymmetric(horizontal: 10),
                  ],
                ),

              5.height,
              if(serviceList.isEmpty)
                Column(
                  children: [
                    NoDataWidget(
                      title: 'Cases No Found',
                      imageWidget: const EmptyStateWidget(),
                      retryText: language.reload,
                    ),
                    10.height,
                    /*Container(
                      decoration: BoxDecoration(
                        color: cardColor1,
                        borderRadius: radius(12),
                        shape: BoxShape.rectangle,
                      ),
                      child: Text('Add Patient',style: boldTextStyle(size: 14,color: white),).paddingSymmetric(horizontal: 20,vertical: 10)
                    ).onTap((){
                        AddPatientscreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                    })*/
                  ],
                ),
              if(serviceList.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: serviceList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    Visit model=serviceList[index];
                    return GestureDetector(
                        onTap: () {
                          showConfirmDialogCustom(
                            context,
                            /*dialogAnimation:
                            DialogAnimation.SLIDE_LEFT_RIGHT,*/
                            title: "Paid This Case",
                            dialogType: DialogType.CONFIRMATION,
                            onAccept: (_) async {
                              appStore.setLoading(true);
                              String date = formatBookingDate(DateTime.now().toString(),format: DATE_FORMAT_72,);
                              await dischargeCase(
                              id: model.id.validate().toString(),
                              caseAmount: model.caseAmount.validate().toString(),
                              paidDate: date,).then((
                                  value) async {
                                appStore.setLoading(false);
                                toast(value.message.validate().toString());
                                if (value.statusCode == 200) {
                                  serviceList.removeAt(index);
                                  setState(() {},);
                                }
                              }).catchError((e) {
                                appStore.setLoading(false);
                                toast(e.toString());
                              });
                            },
                          );
                        },
                        child: ActiveCaseListWidget(model: model,));
                  },
                ).paddingAll(5)
            ],
          ).expand(),
          LinearProgressIndicator(
            minHeight: 10,
            borderRadius: radius(10),
            backgroundColor: cardColor,
            color: primaryColor,
          ).paddingSymmetric(vertical: 5,horizontal: 10).visible(isLoading),
        ],
      ),
    );
  }

 // DateTime currentDateTime = DateTime.now();
  DateTime? selectedDate = DateTime.now();

  void selectDate(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: selectedDate!.subtract(30.days),
      lastDate: selectedDate!.add(30.days),
      locale: Locale(appStore.selectedLanguageCode),
      cancelText: language.lblCancel,
      confirmText: language.lblOk,
      helpText: language.lblSelectDate,
      builder: (_, child) {
        return Theme(
          data: appStore.isDarkMode ? ThemeData.dark() : AppTheme.lightTheme(),
          child: child!,
        );
      },
    ).then((date) async {
      if (date != null) {
        selectedDate = date;

        init();
        setState(() {});
        return await 2.seconds.delay;
        setState(() {});
      }
    });
  }

}
