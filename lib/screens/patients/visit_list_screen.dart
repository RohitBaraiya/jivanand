import 'package:jivanand/component/base_scaffold_widget.dart';
import 'package:jivanand/component/empty_error_state_widget.dart';
import 'package:jivanand/generated/assets.dart';
import 'package:jivanand/main.dart';
import 'package:jivanand/network/rest_apis.dart';
import 'package:jivanand/screens/case/componet/case_list_widget.dart';
import 'package:jivanand/screens/patients/add_patients_screen.dart';
import 'package:jivanand/screens/patients/componet/visit_list_widget.dart';
import 'package:jivanand/screens/patients/model/PatientsListModel.dart';
import 'package:jivanand/screens/patients/model/VisitListMode.dart';
import 'package:jivanand/screens/patients/patient_detail_screen.dart';
import 'package:jivanand/utils/common.dart';
import 'package:jivanand/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:jivanand/utils/string_extensions.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/colors.dart';
import 'dart:async';



class VisitListScreen extends StatefulWidget {
  final String pId;

  const VisitListScreen({super.key, required this.pId});

  @override
  _CatListScreenState createState() => _CatListScreenState();
}

class _CatListScreenState extends State<VisitListScreen> with  SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    setStatusColor();
    init();
  }

  void init() async {
    getPatientVisitData();
  }


  Future<VisitListMode>? future;

  Future<void> getPatientVisitData() async {
    setState(() {
      // Trigger UI rebuild and load the future
      future = getPatientVisit(pId: widget.pId).catchError((e) {
        toast(e.toString());
      });
    });

  }


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }


  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: 'Visit List',
      scaffoldBackgroundColor: bgColor,
      child: AnimatedScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        listAnimationType: ListAnimationType.FadeIn,
        fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
        onSwipeRefresh: () async {
          // appStore.setLoading(true);
          init();
          setState(() {});
          return await 2.seconds.delay;
        },
        children: [
          SnapHelperWidget<VisitListMode>(
            //  initialData: stockList,
            //  loadingWidget: StaffrListShimmer(),
              future: future,
              errorBuilder: (error) {
                return NoDataWidget(
                  title: error,
                  imageWidget: ErrorStateWidget(),
                  retryText: language.reload,
                  onRetry: () {
                    init();
                    setState(() {});
                  },
                );
              },
              onSuccess: (snap) {
                if (snap.data.validate().isEmpty) {
                  return NoDataWidget(
                    title: 'No Data Found',
                    imageWidget: const EmptyStateWidget(),
                    retryText: language.reload,
                  );
                }
                VisitListMode model = snap;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: model.data.validate().length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    VisitListData m1=model.data.validate()[index];
                    return VisitListWidget(model: m1,);},
                ).paddingAll(5);


              }
          ),

        ],
      ),
    );
  }

}
