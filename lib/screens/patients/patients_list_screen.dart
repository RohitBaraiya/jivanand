import 'package:jivanand/component/base_scaffold_widget.dart';
import 'package:jivanand/component/empty_error_state_widget.dart';
import 'package:jivanand/generated/assets.dart';
import 'package:jivanand/main.dart';
import 'package:jivanand/network/rest_apis.dart';
import 'package:jivanand/screens/case/componet/case_list_widget.dart';
import 'package:jivanand/screens/patients/add_patients_screen.dart';
import 'package:jivanand/screens/patients/componet/patients_list_widget.dart';
import 'package:jivanand/screens/patients/model/PatientsListModel.dart';
import 'package:jivanand/screens/patients/patient_detail_screen.dart';
import 'package:jivanand/utils/common.dart';
import 'package:jivanand/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:jivanand/utils/string_extensions.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/colors.dart';
import 'dart:async';


class PatientsListScreen extends StatefulWidget {
  final bool? isFromHome;
  final bool? isFromHomePDF;

  const PatientsListScreen({super.key, this.isFromHome=false ,this.isFromHomePDF=false});

  @override
  _CatListScreenState createState() => _CatListScreenState();
}

class _CatListScreenState extends State<PatientsListScreen> with  SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    setStatusColor();
    init();
    LiveStream().on(LIVESTREAM_PATIENT_SCREEN, (p0) {
      init();
      setState(() {});
    });
  }

  void init() async {
    page = 1;
    serviceList = [];
    _getProduct();
  }

  int page = 1;
  bool isLastPage = false;
  List<PatientsListData> serviceList = [];
  Timer? _debounce;

  void _getProduct() async {
    appStore.setLoading(true);
    await getPatientsWithPagination(page,
      categoryList: serviceList,
      search: nameCont.text.validate().toString().trim(),
      lastPageCallBack: (lastPage) {
        isLastPage = lastPage;
      },

    ).whenComplete(() {
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
    LiveStream().dispose(LIVESTREAM_PATIENT_SCREEN);
  }

  TextEditingController nameCont = TextEditingController();
  FocusNode nameFocus = FocusNode();

  bool isLoading=false;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: widget.isFromHome.validate() ? 'Patients' : 'Search Patient',
      scaffoldBackgroundColor: bgColor,
      actions: [
        if(!widget.isFromHome.validate())
          TextButton(
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            backgroundColor: context.primaryColor,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text('Add Patient', style: boldTextStyle(color: white)),
          onPressed: () {
            AddPatientscreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
          },
        ).paddingRight(10)
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
                   textCapitalization: TextCapitalization.characters,
                   textFieldType: TextFieldType.NAME,
                   controller: nameCont,
                   focus: nameFocus,
                   errorThisFieldRequired: language.requiredText,
                   decoration: inputDecoration(context, labelText: 'Patient Name, Mobile Number'),
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
                       setState(() {});
                     },
                   ).visible(nameCont.text.isNotEmpty),  // Show the close button only when the text is not empty
                   /*onFieldSubmitted: (s) async {
                     page = 1;
                     _getProduct();
                     setState(() {});
                   },*/
                 ).expand(),
                 10.width,
                 GestureDetector(
                   onTap: () {
                     page = 1;
                     _getProduct();
                    // setState(() {});
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
             5.height,
              if(serviceList.isEmpty)
                Column(
                  children: [
                    NoDataWidget(
                      title: 'Patient No Found',
                      imageWidget: const EmptyStateWidget(),
                      retryText: language.reload,
                    ),
                    10.height,
                    if(!widget.isFromHome.validate())
                      Container(
                        decoration: BoxDecoration(
                          color: cardColor1,
                          borderRadius: radius(12),
                          shape: BoxShape.rectangle,
                        ),
                        child: Text('Add Patient',style: boldTextStyle(size: 14,color: white),).paddingSymmetric(horizontal: 20,vertical: 10)
                      ).onTap((){
                          AddPatientscreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                      })
                  ],
                ),
              if(serviceList.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: serviceList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    PatientsListData model=serviceList[index];
                    return PatientsListWidget(isFromHome: widget.isFromHome,isFromHomePDF: widget.isFromHomePDF,
                      model: model,onDelete: (name,cityName,amount,followupDate) async {
                       // toast(name);
                        await addCase(id: model.id.validate().toString(),vaidId: name,cityName: cityName,caseAmount: amount,followupDate: followupDate).then((value) async {
                          appStore.setLoading(false);
                          toast(value.message.validate().toString());
                          if(value.statusCode == 200) {
                           /* init();
                            setState(() {});*/
                           // return await 2.seconds.delay;
                            finish(context);
                            OfferFromDetailScreen(pid:  model.id.validate().toString(),).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);

                          }
                        }).catchError((e) {
                          appStore.setLoading(false);
                          toast(e.toString());
                        });
                      },);
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

}
