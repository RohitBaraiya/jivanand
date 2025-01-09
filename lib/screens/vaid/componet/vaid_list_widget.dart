import 'package:jivanand/component/box_widget.dart';
import 'package:jivanand/generated/assets.dart';
import 'package:jivanand/main.dart';
import 'package:jivanand/screens/case/vaid_name_screen.dart';
import 'package:jivanand/screens/patients/model/PatientsListModel.dart';
import 'package:jivanand/screens/patients/patient_detail_screen.dart';
import 'package:jivanand/screens/vaid/model/VaidListModel.dart';
import 'package:jivanand/utils/colors.dart';
import 'package:jivanand/utils/common.dart';
import 'package:jivanand/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';


class VaidListWidget extends StatefulWidget {
  final VaidListData model;
  final Function()? onDelete;

  const VaidListWidget({super.key, required this.model, required this.onDelete,});

  @override
  State<VaidListWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<VaidListWidget> {


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
       /*if(widget.isFromHome.validate()){
         OfferFromDetailScreen(pid:  widget.model.id.validate().toString(),).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
       }*/
      },
      child: BoxWidget(
        child:Row(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 10.width,
                Container(
                    decoration: const BoxDecoration(color: white, shape: BoxShape.rectangle),
                    child: Assets.jivanandAyurvedic.iconImage2(size: 40).paddingAll(8)
                ).cornerRadiusWithClipRRect(10),
                10.width,
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(widget.model.name.validate().toString().capitalizeEachWord(),style: boldTextStyle(size: 16,color: textColor),),
                    Text('Mobile - ${widget.model.mobileNo.validate().toString()}',style: secondaryTextStyle(size: 12,color: textColor),),
                    Text('Gender - ${widget.model.gender.validate().toString().capitalizeEachWord()}',style: secondaryTextStyle(size: 12,color: textColor),),
                    Text('Address - ${widget.model.address.validate().toString().capitalizeEachWord()}',style: secondaryTextStyle(size: 12,color: textColor),),
                    Text('Pincode - ${widget.model.pinCode.validate().toString().capitalizeEachWord()}',style: secondaryTextStyle(size: 12,color: textColor),),
                    Text('Email - ${widget.model.email.validate().toString().capitalizeEachWord()}',style: secondaryTextStyle(size: 12,color: textColor),),
                  ],
                ),
              ],
            ).paddingAll(10).expand(),

            Row(
              children: [
                GestureDetector(
                  onTap: () {

                    showConfirmDialogCustom(
                      context,
                      width: context.width(),
                      dialogType: DialogType.CONFIRMATION,
                      title: 'Are you sure Delete ?',
                      subTitle: 'Name - ${widget.model.name.validate().toString()} ',
                      positiveText: language.lblYes,
                      negativeText: language.lblNo,
                      onAccept: (p0) async {
                        widget.onDelete!.call();
                        setState(() {},);
                      },
                    );
                  },
                  child: Container(
                      decoration: BoxDecoration(color: appStore.isDarkMode ? Colors.white24 : context.cardColor, shape: BoxShape.rectangle),
                      child: Assets.jivanandDelete.iconImage2(size: 26).paddingAll(8)
                  ).cornerRadiusWithClipRRect(10),
                ),
              ],
            ).paddingRight(10),
          ],
        ),
      ),
    ).paddingSymmetric(vertical: 5,horizontal: 5);
  }
}
