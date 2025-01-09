import 'package:jivanand/component/box_widget.dart';
import 'package:jivanand/generated/assets.dart';
import 'package:jivanand/main.dart';
import 'package:jivanand/screens/case/model/CaseListModel.dart';
import 'package:jivanand/screens/patients/model/PatientsListModel.dart';
import 'package:jivanand/screens/patients/patient_detail_screen.dart';
import 'package:jivanand/utils/colors.dart';
import 'package:jivanand/utils/common.dart';
import 'package:jivanand/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/constant.dart';


class CaseListWidget extends StatefulWidget {
  final CaseData model;

  const CaseListWidget({super.key, required this.model,});

  @override
  State<CaseListWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<CaseListWidget> {


  @override
  void initState() {
    super.initState();

    init();
  }

  void init() async {
   // log('$BASE_URL_PRODUCT_IMG${widget.model.image.validate().toString()}');
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        OfferFromDetailScreen(pid: widget.model.patientId.validate().toString(),).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
      },
      child: BoxWidget(
        child:Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 10.width,
            Container(
                decoration: const BoxDecoration(color: white, shape: BoxShape.rectangle),
                child: Assets.jivanandHealthcare4.iconImage2(size: 40).paddingAll(8)
            ).cornerRadiusWithClipRRect(10),
            10.width,
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text('${widget.model.patientDetails!.padvi.validate().toString().capitalizeEachWord()} ${widget.model.patientDetails!.name.validate().toString().capitalizeEachWord()}',style: boldTextStyle(size: 16,color: textColor),),
                Text('Age - ${widget.model.patientDetails!.age.validate().toString()}',style: secondaryTextStyle(size: 12,color: textColor),),
                Text('Samuday - ${widget.model.patientDetails!.samudai.validate().toString().capitalizeEachWord()}',style: secondaryTextStyle(size: 12,color: textColor),),
                Text('Sevak - ${widget.model.patientDetails!.sevak.validate().toString().capitalizeEachWord()} (${widget.model.patientDetails!.mobileNo.validate().toString().capitalizeEachWord()})',style: secondaryTextStyle(size: 12,color: textColor),),
                Container(
                  color: newCardColor2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Visit',style: primaryTextStyle(size: 10,color: textColor),),
                          Text('-',style: primaryTextStyle(size: 10,color: textColor),).paddingSymmetric(horizontal: 2),
                          Text('${formatBookingDate(widget.model.visitDate.validate().toString(),format: DATE_FORMAT_DAY_MONTH_YEAR_TIME,)}',style: boldTextStyle(size: 10,color: textColor),),
                           ],
                      ),
                      Row(
                        children: [
                          Text('Location',style: primaryTextStyle(size: 10,color: textColor),),
                          Text('-',style: primaryTextStyle(size: 10,color: textColor),).paddingSymmetric(horizontal: 2),
                          Text(widget.model.city.validate().toString().capitalizeEachWord(),style: boldTextStyle(size: 10,color: textColor),),
                        ],
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 5,vertical: 3),
                ).cornerRadiusWithClipRRect(5)
              ],
            ),
          ],
        ).paddingAll(10),
      ),
    ).paddingSymmetric(vertical: 5,horizontal: 5);
  }
}
