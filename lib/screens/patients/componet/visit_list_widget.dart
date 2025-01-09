import 'package:jivanand/component/box_widget.dart';
import 'package:jivanand/generated/assets.dart';
import 'package:jivanand/main.dart';
import 'package:jivanand/network/rest_apis.dart';
import 'package:jivanand/screens/case/vaid_name_screen.dart';
import 'package:jivanand/screens/patients/model/PatientsListModel.dart';
import 'package:jivanand/screens/patients/model/VisitListMode.dart';
import 'package:jivanand/screens/patients/patient_detail_screen.dart';
import 'package:jivanand/utils/colors.dart';
import 'package:jivanand/utils/common.dart';
import 'package:jivanand/utils/constant.dart';
import 'package:jivanand/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';


class VisitListWidget extends StatefulWidget {
  final VisitListData model;

  const VisitListWidget({super.key, required this.model,});

  @override
  State<VisitListWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<VisitListWidget> {


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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 10.width,
              Container(
                  decoration: const BoxDecoration(color: white, shape: BoxShape.rectangle),
                  child: Assets.jivanandHealthcare4.iconImage2(size: 40).paddingAll(8)
              ).cornerRadiusWithClipRRect(10),
              10.width,
              Container(
                width: context.width(),
                color: newCardColor2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Vaidya Name - ${widget.model.vaidName.validate().toString().capitalizeEachWord()}',style: primaryTextStyle(size: 12,color: textColor),),
                    Text('Visit Date - ${formatBookingDate(widget.model.visitDate.validate().toString(),format: DATE_FORMAT_DAY_MONTH_YEAR_TIME,)}',style: primaryTextStyle(size: 12,color: textColor),),
                    Text('Location - ${widget.model.city.validate().toString().capitalizeEachWord()}',style: boldTextStyle(size: 12,color: textColor),),
                  ],
                ).paddingSymmetric(horizontal: 8,vertical: 8),
              ).cornerRadiusWithClipRRect(5).expand(),
            ],
          ).paddingAll(10).expand(),
        ],
      ),
    ).paddingSymmetric(vertical: 5,horizontal: 5);
  }
}
