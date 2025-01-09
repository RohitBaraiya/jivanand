import 'package:jivanand/component/box_widget.dart';
import 'package:jivanand/generated/assets.dart';
import 'package:jivanand/main.dart';
import 'package:jivanand/screens/case/model/ActiveCaseListModel.dart';
import 'package:jivanand/screens/case/model/CaseListModel.dart';
import 'package:jivanand/utils/colors.dart';
import 'package:jivanand/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:jivanand/utils/string_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/constant.dart';


class ActiveCaseListWidget extends StatefulWidget {
  final Visit model;

  const ActiveCaseListWidget({super.key, required this.model,});

  @override
  State<ActiveCaseListWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<ActiveCaseListWidget> {


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
    return BoxWidget(
      child:Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 10.width,
              Container(
                  decoration: const BoxDecoration(color: white, shape: BoxShape.rectangle),
                  child: Assets.jivanandHospitalisation.iconImage2(size: 40).paddingAll(8)
              ).cornerRadiusWithClipRRect(10),
              10.width,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.model.patient!.padvi.validate().toString().capitalizeEachWord()} ${widget.model.patient!.name.validate().toString().capitalizeEachWord()}',style: boldTextStyle(size: 16,color: textColor),),
                  Text('Location - ${widget.model.city.validate().toString()}',style: secondaryTextStyle(size: 12,color: textColor),),
                 // Text('Amount - ${widget.model.caseAmount.validate().toString().capitalizeEachWord()}',style: secondaryTextStyle(size: 12,color: textColor),),
                 // Text('Sevak - ${widget.model.patientDetails!.sevak.validate().toString().capitalizeEachWord()} (${widget.model.patientDetails!.mobileNo.validate().toString().capitalizeEachWord()})',style: secondaryTextStyle(size: 12,color: textColor),),
                  4.height,
                  /*Container(
                    color: newCardColor2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Hospital Name',style: primaryTextStyle(size: 10,color: textColor),),
                            Text('-',style: primaryTextStyle(size: 10,color: textColor),).paddingSymmetric(horizontal: 2),
                            Text(widget.model.hospitalName.validate().toString().capitalizeEachWord(),style: boldTextStyle(size: 10,color: textColor),),
                          ],
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 5,vertical: 3),
                  ).cornerRadiusWithClipRRect(5),*/
                  4.height,
                  Container(
                    color: newCardColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Total Amount',style: primaryTextStyle(size: 10,color: white),),
                            Text('-',style: primaryTextStyle(size: 10,color: white),).paddingSymmetric(horizontal: 2),
                            Text('₹ ${widget.model.caseAmount.validate().toString()} /-',style: boldTextStyle(size: 10,color: white),),
                          ],
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 5,vertical: 3),
                  ).cornerRadiusWithClipRRect(5)
                ],
              ),
            ],
          ).paddingAll(10).expand(),
          Container(
            //  decoration:  BoxDecoration(color: getCaseStatusColor(widget.model.status.validate().toString()), shape: BoxShape.rectangle),
              child: Text('${widget.model.paidStatus.toString() == '0' ? '🟢' : '🔴'}',style: primaryTextStyle(size: 14,color: white),).paddingSymmetric(horizontal: 2,vertical: 2)
          ).cornerRadiusWithClipRRect(8),
        ],
      ),
    ).paddingSymmetric(vertical: 5,horizontal: 5);
  }
}
