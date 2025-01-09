import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jivanand/component/base_scaffold_widget.dart';
import 'package:jivanand/component/cached_image_widget.dart';
import 'package:jivanand/component/empty_error_state_widget.dart';
import 'package:jivanand/db/db_helper.dart';
import 'package:jivanand/db/model/CartModel.dart';
import 'package:jivanand/generated/assets.dart';
import 'package:jivanand/main.dart';
import 'package:jivanand/model/MsgModel.dart';
import 'package:jivanand/network/network_utils.dart';
import 'package:jivanand/network/rest_apis.dart';
import 'package:jivanand/screens/patients/model/PatientsListModel.dart';
import 'package:jivanand/screens/patients/visit_list_screen.dart';
import 'package:jivanand/screens/pdf/new_rohit_dialog.dart';
import 'package:jivanand/screens/zoom_image_screen.dart';
import 'package:jivanand/utils/common.dart';
import 'package:jivanand/utils/constant.dart';
import 'package:jivanand/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:jivanand/utils/string_extensions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../utils/colors.dart';

class PdfScreen extends StatefulWidget {
  final String pid;

  PdfScreen({super.key, required this.pid});

  @override
  _PdfScreenState createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> with  SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    setStatusColor();
    init();
  }

  Future<PatientsListData>? future;

  Future<void> getPatientDetailData() async {
    setState(() {
      // Trigger UI rebuild and load the future
      future = getPatientDetail(pId: widget.pid).catchError((e) {
        toast(e.toString());
      });
    });

  }

  void init() async {
    getPatientDetailData();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }



  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: 'Create PDF',
      scaffoldBackgroundColor: bgColor,
      actions: [
          TextButton(
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              backgroundColor: context.primaryColor,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text('Medical History', style: boldTextStyle(color: white,size: 12)),
            onPressed: () {


            },
          ).paddingRight(10)
      ],
      child: AnimatedScrollView(
        controller: _controller,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        listAnimationType: ListAnimationType.FadeIn,
        fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
        onSwipeRefresh: () async {
          init();
          setState(() {});
          return await 2.seconds.delay;
        },
        children: [


          SnapHelperWidget<PatientsListData>(
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
                if (snap.files.validate().isEmpty) {
                  return NoDataWidget(
                    title: 'No File Found',
                    imageWidget: const EmptyStateWidget(),
                    retryText: language.reload,
                  );
                }
                PatientsListData model = snap;

                List<Files> newFiles =[];
                if(model.files.validate().isNotEmpty){
                  newFiles = model.files.validate();
                  /*if(newFiles.length > 1){
                    newFiles.removeAt(0);
                  }*/
                }

                return Column(
                 children: [
                   Column(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         ListView.builder(
                           shrinkWrap: true,
                           physics: const NeverScrollableScrollPhysics(),
                           itemCount: newFiles.length,
                           scrollDirection: Axis.vertical,
                           itemBuilder: (context, index) {
                             Files fileModel = newFiles[index];
                             String d1 = (fileModel.images.validate().length > 0)
                                 ? fileModel.images.validate()[0].image.validate().toString()
                                 : '';

                             String d2 = (fileModel.images.validate().length > 1)
                                 ? fileModel.images.validate()[1].image.validate().toString()
                                 : '';

                             String p1 = (fileModel.images.validate().length > 2)
                                 ? fileModel.images.validate()[2].image.validate().toString()
                                 : '';

                             String p2 = (fileModel.images.validate().length > 3)
                                 ? fileModel.images.validate()[3].image.validate().toString()
                                 : '';

                             CachedNetworkImage.evictFromCache(d1);
                             CachedNetworkImage.evictFromCache(d2);
                             CachedNetworkImage.evictFromCache(p1);
                             CachedNetworkImage.evictFromCache(p2);

                             return Card(
                               color: cardColor,
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(5),
                               ),
                               margin: EdgeInsets.zero,
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   10.height,
                                   Text('➺ File : ${fileModel.fileNumber.validate().toString()}', style: boldTextStyle(color: textColor, size: 14),).paddingSymmetric(horizontal: 10),
                                   Row(
                                     children: [
                                       Container(
                                         width: context.width(),
                                         color: newCardColor2,
                                         padding: EdgeInsets.all(5),
                                         child: Column(
                                           children: [
                                             CachedImageWidget(
                                               url: d1,
                                               height: 100,
                                               width: context.width(),
                                               fit: BoxFit.cover,
                                               circle: false,
                                               radius: 5,
                                             ).cornerRadiusWithClipRRect(5).onTap((){
                                               _gotoNext(img: d1);
                                             }),
                                           ],
                                         ),
                                       ).cornerRadiusWithClipRRect(8).expand(),
                                       5.width,
                                       Container(
                                         width: context.width(),
                                         color: newCardColor2,
                                         padding: EdgeInsets.all(5),
                                         child: Column(
                                           children: [
                                             CachedImageWidget(
                                               url: d2,
                                               height: 100,
                                               width: context.width(),
                                               fit: BoxFit.cover,
                                               circle: false,
                                               radius: 5,
                                             ).cornerRadiusWithClipRRect(5).cornerRadiusWithClipRRect(5).onTap((){
                                               _gotoNext(img: d2);
                                             }),
                                           ],
                                         ),
                                       ).cornerRadiusWithClipRRect(8).expand(),
                                       5.width,
                                       Container(
                                         width: context.width(),
                                         color: newCardColor2,
                                         padding: EdgeInsets.all(5),
                                         child: Column(
                                           children: [
                                             CachedImageWidget(
                                               url: p1,
                                               height: 100,
                                               width: context.width(),
                                               fit: BoxFit.cover,
                                               circle: false,
                                               radius: 5,
                                             ).cornerRadiusWithClipRRect(5).cornerRadiusWithClipRRect(5).onTap((){
                                               _gotoNext(img: p1);
                                             }),
                                           ],
                                         ),
                                       ).cornerRadiusWithClipRRect(8).expand(),
                                       5.width,
                                       Container(
                                         width: context.width(),
                                         color: newCardColor2,
                                         padding: EdgeInsets.all(5),
                                         child: Column(
                                           children: [
                                             CachedImageWidget(
                                               url: p2,
                                               height: 100,
                                               width: context.width(),
                                               fit: BoxFit.cover,
                                               circle: false,
                                               radius: 5,
                                             ).cornerRadiusWithClipRRect(5).cornerRadiusWithClipRRect(5).onTap((){
                                               _gotoNext(img: p2);
                                             }),
                                           ],
                                         ),
                                       ).cornerRadiusWithClipRRect(8).expand(),
                                     ],
                                   ).paddingAll(5),
                                   10.height,
                                   GestureDetector(
                                     onTap: () {
                                       showInDialog(
                                         context,
                                         barrierDismissible: false,
                                         builder: (BuildContext context) => NewRohitDialog(list: fileModel.images,isPdf: true,),
                                         backgroundColor: transparentColor,
                                         contentPadding: EdgeInsets.zero,
                                       );
                                     },
                                     child: Container(
                                       width: context.width(),
                                       color: primaryColor,
                                       padding: EdgeInsets.all(5),
                                       child: Column(
                                         children: [
                                           Text('Create PDF', style: boldTextStyle(color: white, size: 14),).paddingSymmetric(horizontal: 10,vertical: 4),
                                           ]
                                       )
                                     ).cornerRadiusWithClipRRect(10).paddingSymmetric(horizontal: 10),
                                   ),
                                   10.height,
                                 ],
                               ),

                             ).paddingSymmetric(horizontal: 5,vertical: 5);
                           },
                         ).paddingAll(5),
                       ],
                     ),
                   50.height,
                 ],
                );
              }
          ),
        ],
      ),
    );
  }






  void _gotoNext({required String img}){
    if (img.toString().isNotEmpty) ZoomImageScreen(galleryImages: [img], index: 0).launch(context);
  }

}
