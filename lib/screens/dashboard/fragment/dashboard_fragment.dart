import 'package:jivanand/generated/assets.dart';
import 'package:jivanand/main.dart';
import 'package:jivanand/screens/case/case_list_screen.dart';
import 'package:jivanand/screens/dashboard/component/greetings_component.dart';
import 'package:jivanand/screens/dashboard/component/slider_and_location_component.dart';
import 'package:jivanand/screens/patients/add_patients_screen.dart';
import 'package:jivanand/screens/patients/patient_detail_screen.dart';
import 'package:jivanand/screens/patients/patients_list_screen.dart';
import 'package:jivanand/screens/vaid/add_vaid_screen.dart';
import 'package:jivanand/screens/vaid/vaid_list_screen.dart';
import 'package:jivanand/utils/common.dart';
import 'package:jivanand/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jivanand/utils/string_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/box_widget.dart';
import '../../../component/loader_widget.dart';

class DashboardFragment extends StatefulWidget {
  const DashboardFragment({super.key});

  @override
  _DashboardFragmentState createState() => _DashboardFragmentState();
}

class _DashboardFragmentState extends State<DashboardFragment> with WidgetsBindingObserver {
 // Future<DashboardResponse>? future;
  

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    // log('Background');
    if (state == AppLifecycleState.resumed) {
      LiveStream().emit(LIVESTREAM_UPDATE_DASHBOARD);
      /*log('Background');
      if(appStore.isLogOut==true){
        log('userLogOut');
        userLogOut();
      }*/
    }
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    init();
    setStatusColor();
    getDayMsg();
    LiveStream().on(LIVESTREAM_UPDATE_DASHBOARD, (p0) {
      init();
      setState(() {});
    });
  }

  void init() async {
    getDashboardData();
  }


  Future<void> getDashboardData() async {

  }


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    LiveStream().dispose(LIVESTREAM_UPDATE_DASHBOARD);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
        backgroundColor: bgColor,
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(color: cardColor, shape: BoxShape.rectangle),
                  width: context.width(),
                  child: _titleBar(context, greeting),
                ),
                AnimatedScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  listAnimationType: ListAnimationType.FadeIn,
                  fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                  onSwipeRefresh: () async {
                    // appStore.setLoading(true);
                    init();
                    setState(() {});
                    return await 2.seconds.delay;
                  },
                  children: [
                    //2.height,
                    SliderLocationComponent(
                      sliderList: bannerList.validate(),
                      callback: () async {
                        appStore.setLoading(true);

                        init();
                        setState(() {});
                      },
                    ),
                    10.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async{
                            //OfferFromDetailScreen(pid: '1',).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                            PatientsListScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                          },
                          child: BoxWidget(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                10.height,
                                Container(
                                    decoration: BoxDecoration(color: appStore.isDarkMode ? Colors.white24 : context.cardColor, shape: BoxShape.rectangle),
                                    child: Assets.jivanandReceptionist.iconImage2(size: homeSubIconSize).paddingAll(8)
                                ).cornerRadiusWithClipRRect(10),
                                10.height,
                                Text('Add Case',style: boldTextStyle(size: homeSubTitleName,color: textColor),).center(),
                                10.height,
                              ],
                            ),
                          ),
                        ).paddingSymmetric(vertical: 5).expand(),
                        10.width,
                        GestureDetector(
                          onTap: () async{
                            const CaseListScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                          },
                          child: BoxWidget(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                10.height,
                                Container(
                                    decoration: BoxDecoration(color: appStore.isDarkMode ? Colors.white24 : context.cardColor, shape: BoxShape.rectangle),
                                    child: Assets.jivanandCalendar.iconImage2(size: homeSubIconSize).paddingAll(8)
                                ).cornerRadiusWithClipRRect(10),
                                10.height,
                                Text('Today Case',style: boldTextStyle(size: homeSubTitleName,color: textColor),).center(),
                                10.height,
                              ],
                            ),
                          ),
                        ).paddingSymmetric(vertical: 5).expand(),
                        10.width,
                        GestureDetector(
                          onTap: () async{
                            PatientsListScreen(isFromHome: true,).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                          },
                          child: BoxWidget(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                10.height,
                                Container(
                                    decoration: BoxDecoration(color: appStore.isDarkMode ? Colors.white24 : context.cardColor, shape: BoxShape.rectangle),
                                    child: Assets.jivanandBuddha.iconImage2(size: homeSubIconSize).paddingAll(8)
                                ).cornerRadiusWithClipRRect(10),
                                10.height,
                                Text('Patients',style: boldTextStyle(size: homeSubTitleName,color: textColor),).center(),
                                10.height,
                              ],
                            ),
                          ),
                        ).paddingSymmetric(vertical: 5).expand()

                      ],
                    ).paddingSymmetric(horizontal: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async{
                            //OfferFromDetailScreen(pid: '1',).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                            VaidListScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                          },
                          child: BoxWidget(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                10.height,
                                Container(
                                    decoration: BoxDecoration(color: appStore.isDarkMode ? Colors.white24 : context.cardColor, shape: BoxShape.rectangle),
                                    child: Assets.jivanandAyurvedic.iconImage2(size: homeSubIconSize).paddingAll(8)
                                ).cornerRadiusWithClipRRect(10),
                                10.height,
                                Text('Vaidya',style: boldTextStyle(size: homeSubTitleName,color: textColor),).center(),
                                10.height,
                              ],
                            ),
                          ),
                        ).paddingSymmetric(vertical: 5).expand(),
                        10.width,
                        GestureDetector(
                          onTap: () async{
                           // const CaseListScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                            toast('Coming soon');
                          },
                          child: BoxWidget(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                10.height,
                                Container(
                                    decoration: BoxDecoration(color: appStore.isDarkMode ? Colors.white24 : context.cardColor, shape: BoxShape.rectangle),
                                    child: Assets.jivanandMedicalReport.iconImage2(size: homeSubIconSize).paddingAll(8)
                                ).cornerRadiusWithClipRRect(10),
                                10.height,
                                Text('Followup',style: boldTextStyle(size: homeSubTitleName,color: textColor),).center(),
                                10.height,
                              ],
                            ),
                          ),
                        ).paddingSymmetric(vertical: 5).expand(),
                        10.width,
                        GestureDetector(
                          onTap: () async{
                            //PatientsListScreen(isFromHome: true,).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                            //toast('Coming soon');
                            PatientsListScreen(isFromHome: true,isFromHomePDF: true,).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                          },
                          child: BoxWidget(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                10.height,
                                Container(
                                    decoration: BoxDecoration(color: appStore.isDarkMode ? Colors.white24 : context.cardColor, shape: BoxShape.rectangle),
                                    child: Assets.jivanandPdfColor.iconImage2(size: homeSubIconSize).paddingAll(8)
                                ).cornerRadiusWithClipRRect(10),
                                10.height,
                                Text('Case Paper PDF',style: boldTextStyle(size: homeSubTitleName,color: textColor),).center(),
                                10.height,
                              ],
                            ),
                          ),
                        ).paddingSymmetric(vertical: 5).expand()

                      ],
                    ).paddingSymmetric(horizontal: 10),
                    50.height,
                  ],
                ).expand()
              ],
            ),
            Observer(builder: (context) => const LoaderWidget().visible(appStore.isLoading)),
          ],
        ),

      ),
    );
  }

  List<String> bannerList = [
    Assets.bannerB1,
    Assets.bannerB2,
    Assets.bannerB3,
    Assets.bannerB4,
    Assets.bannerB5,
   // Assets.bannerB6,
  ];

  Widget _titleBar(BuildContext context,String greeting){
    return GreetingsComponent(msg: greeting,);
  }


  String greeting = "";
  Future<void> getDayMsg() async {
    DateTime now = DateTime.now();
    int hours=now.hour;
    if(hours>=1 && hours<=6){
      greeting = "Mornin' Sunshine!";
    }else if(hours>=6 && hours<=12){
      greeting = "Good Morning";
    } else if(hours>=12 && hours<=16){
      greeting = "Good Afternoon";
    } else if(hours>=16 && hours<=21){
      greeting = "Good Evening";
    } else if(hours>=21 && hours<=24){
      greeting = "Go to Bed!";
    }
  }


}
