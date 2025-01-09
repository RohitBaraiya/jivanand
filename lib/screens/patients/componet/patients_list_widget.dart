import 'package:jivanand/component/box_widget.dart';
import 'package:jivanand/generated/assets.dart';
import 'package:jivanand/main.dart';
import 'package:jivanand/network/rest_apis.dart';
import 'package:jivanand/screens/case/vaid_name_screen.dart';
import 'package:jivanand/screens/patients/model/PatientsListModel.dart';
import 'package:jivanand/screens/patients/patient_detail_screen.dart';
import 'package:jivanand/screens/pdf/pdf_screen.dart';
import 'package:jivanand/utils/colors.dart';
import 'package:jivanand/utils/common.dart';
import 'package:jivanand/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';


class PatientsListWidget extends StatefulWidget {
  final PatientsListData model;
  final Function(String name, String locationName)? onDelete;
  final bool? isFromHome;
  final bool? isFromHomePDF;

  const PatientsListWidget({super.key, required this.model, required this.onDelete, this.isFromHome=false,this.isFromHomePDF=false});

  @override
  State<PatientsListWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<PatientsListWidget> {


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
       if(widget.isFromHome.validate() && widget.isFromHomePDF.validate()){
         PdfScreen(pid:  widget.model.id.validate().toString(),).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
       }else if(widget.isFromHome.validate()){
         OfferFromDetailScreen(pid:  widget.model.id.validate().toString(),).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
       }
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
                    child: Assets.jivanandPatient.iconImage2(size: 40).paddingAll(8)
                ).cornerRadiusWithClipRRect(10),
                10.width,
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(widget.model.name.validate().toString().capitalizeEachWord(),style: boldTextStyle(size: 16,color: textColor),),
                    Text('Age - ${widget.model.age.validate().toString()}',style: secondaryTextStyle(size: 12,color: textColor),),
                    Text('Samuday - ${widget.model.samudai.validate().toString().capitalizeEachWord()}',style: secondaryTextStyle(size: 12,color: textColor),),
                    Text('Sevak - ${widget.model.sevak.validate().toString().capitalizeEachWord()} (${widget.model.mobileNo.validate().toString().capitalizeEachWord()})',style: secondaryTextStyle(size: 12,color: textColor),),
                  ],
                ),
              ],
            ).paddingAll(10).expand(),
            if(!widget.isFromHome.validate())
              Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    appStore.setLoading(true);
                    await getAllVaidList().then((value) async {
                      appStore.setLoading(false);

                      if (value.statusCode == 200) {
                          showInDialog(
                            context,
                            contentPadding: EdgeInsets.zero,
                            dialogAnimation: DialogAnimation.SLIDE_TOP_BOTTOM,
                            builder: (_) => VaidNameScreen(onComplete: (name,locationName) {
                              widget.onDelete!.call(name,locationName);
                              setState(() {},);
                            },),
                            /*builder: (_) => VaidNameScreen(onComplete: (name) {
                              widget.onDelete!.call(name);
                              setState(() {},);
                            },),*/
                          );

                      }else{
                        toast(value.message.validate().toString());
                      }
                    }).catchError((e) {
                      appStore.setLoading(false);
                      toast(e.toString());
                    });



                    /*showConfirmDialogCustom(
                      context,
                      width: context.width(),
                      dialogType: DialogType.CONFIRMATION,
                      title: 'Confirmation For Patient',
                      subTitle: 'Name - ${widget.model.padvi.validate().toString()} ${widget.model.name.validate().toString()} (Age - ${widget.model.age.validate().toString()})\n Samudai - ${widget.model.samudai.validate().toString()}',
                      positiveText: language.lblYes,
                      negativeText: language.lblNo,
                      onAccept: (p0) async {
                        widget.onDelete!.call();
                        setState(() {},);
                      },
                    );*/
                  },
                  child: Container(
                      decoration: BoxDecoration(color: appStore.isDarkMode ? Colors.white24 : context.cardColor, shape: BoxShape.rectangle),
                      child: Assets.appIconNewAdd.iconImage2(size: 26).paddingAll(8)
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
