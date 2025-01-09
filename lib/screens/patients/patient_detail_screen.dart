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

class OfferFromDetailScreen extends StatefulWidget {
  final String pid;

  OfferFromDetailScreen({super.key, required this.pid});

  @override
  _OfferFromDetailScreenState createState() => _OfferFromDetailScreenState();
}

class _OfferFromDetailScreenState extends State<OfferFromDetailScreen> with  SingleTickerProviderStateMixin{

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

  File? _compressedImageFile;

  Future<void> _compressImageToWebP(File imageFile) async {
    final imageBytes = await imageFile.readAsBytes();
    final result = await FlutterImageCompress.compressWithList(
      imageBytes,
      quality: 100,  // Adjust quality (0 to 100) for lossy compression
      format: CompressFormat.webp, // Specify WebP format
    );
    String baseFileName = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());

    final downloadDirectory = Directory('/data/user/0/com.jito.jivanand/cache/Jivanand');
    if (!await downloadDirectory.exists()) {
      await downloadDirectory.create(recursive: true);
    }

    final compressedImage = File('${downloadDirectory.path}/$baseFileName.webp')..writeAsBytesSync(result);

    setState(() {
      _compressedImageFile = compressedImage;
      print('Compressed image saved at: $compressedImage');
    });
  }


  void uploadImage({required String page, required String fileId, required String pId, required File imageFile}) async {

    hideKeyboard(context);
    if (appStore.isLoading) return;

    appStore.setLoading(true);
        MultipartRequest multiPartRequest = await getMultiPartRequest('upload_image', urlType: 'my');
        multiPartRequest.fields['patient_id'] = pId;
        multiPartRequest.fields['file_id'] = fileId;
        multiPartRequest.fields['page_number'] = page;
        if (imageFile != null) {
          await _compressImageToWebP(File(imageFile!.path));
          multiPartRequest.files.add(await MultipartFile.fromPath('image', _compressedImageFile!.path));
        }

        multiPartRequest.headers.addAll(buildHeaderTokens(urlType: 'my'));


        sendMultiPartRequest(
          multiPartRequest,
          onSuccess: (data) async {
            appStore.setLoading(false);
            if (data != null) {
              if ((data as String).isJson()) {
                MsgModel res = MsgModel.fromJson(jsonDecode(data));

                toast(res.message.validate().capitalizeFirstLetter());
                if(res.statusCode == 200) {
                 // init();
                  finish(context);
                  OfferFromDetailScreen(pid:  widget.pid.validate().toString(),).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);

                }

              }
            }
          },
          onError: (error) {
            toast(error.toString(), print: true);
            appStore.setLoading(false);
          },
        ).catchError((e) {
          appStore.setLoading(false);
          toast(e.toString(), print: true);
        });


  }


  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: 'Patient Detail',
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
               VisitListScreen(pId: widget.pid,).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
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
                /*if (snap.catList.validate().isEmpty) {
                  return NoDataWidget(
                    title: 'No Data Found',
                    imageWidget: const EmptyStateWidget(),
                    retryText: language.reload,
                  );
                }*/
                PatientsListData model = snap;
                String d1 = '';
                String d2 = '';
                String p1 = '';
                String p2 = '';
                List<Files> newFiles =[];
                String uploadFileNumber = '';
                if(model.files.validate().isNotEmpty){
                  /*d1 = model.files.validate().first.images.validate()[0].image.validate().toString();
                  d2 = model.files.validate().first.images.validate()[1].image.validate().toString();
                  p1 = model.files.validate().first.images.validate()[2].image.validate().toString();
                  p2 = model.files.validate().first.images.validate()[3].image.validate().toString();*/

                  d1 = (model.files.validate().first.images.validate().length > 0)
                      ? model.files.validate().first.images.validate()[0].image.validate().toString()
                      : '';

                  d2 = (model.files.validate().first.images.validate().length > 1)
                      ? model.files.validate().first.images.validate()[1].image.validate().toString()
                      : '';

                  p1 = (model.files.validate().first.images.validate().length > 2)
                      ? model.files.validate().first.images.validate()[2].image.validate().toString()
                      : '';

                  p2 = (model.files.validate().first.images.validate().length > 3)
                      ? model.files.validate().first.images.validate()[3].image.validate().toString()
                      : '';


                  CachedNetworkImage.evictFromCache(d1);
                  CachedNetworkImage.evictFromCache(d2);
                  CachedNetworkImage.evictFromCache(p1);
                  CachedNetworkImage.evictFromCache(p2);

                  uploadFileNumber = model.files.validate().first.fileNumber.validate().toString();

                  newFiles = model.files.validate();
                  if(newFiles.length > 1){
                    newFiles.removeAt(0);
                  }
                }else{
                  uploadFileNumber ='1';
                }


                return Column(
                 children: [
                   Card(
                     color: newCardColor2,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(5),
                     ),
                     margin: EdgeInsets.zero,
                     child: Column(
                       children: [
                         Row(
                           children: [
                             Text('Name - ',style: boldTextStyle(size: 14, color: textColor),),
                             2.width,
                             Text('${model.padvi.validate().toString().capitalizeEachWord()} ${model.name.validate().toString().capitalizeEachWord()}',style: primaryTextStyle(size: 14, color: textColor),),
                           ],
                         ),
                         Row(
                           children: [
                             Text('Age - ',style: boldTextStyle(size: 14, color: textColor),),
                             2.width,
                             Text('${model.age.validate().toString()} Years',style: primaryTextStyle(size: 14, color: textColor),),
                           ],
                         ),
                         Row(
                           children: [
                             Text('Samudai - ',style: boldTextStyle(size: 14, color: textColor),),
                             2.width,
                             Text('${model.samudai.validate().toString().capitalizeEachWord()}',style: primaryTextStyle(size: 14, color: textColor),),
                           ],
                         ),
                         Row(
                           children: [
                             Text('Savak - ',style: boldTextStyle(size: 14, color: textColor),),
                             2.width,
                             Text('${model.sevak.validate().toString().capitalizeEachWord()}',style: primaryTextStyle(size: 14, color: textColor),),
                           ],
                         ),
                         Row(
                           children: [
                             Text('Mobile No. - ',style: boldTextStyle(size: 14, color: textColor),),
                             5.width,
                             Text('${model.mobileNo.validate().toString().capitalizeEachWord()}',style: primaryTextStyle(size: 14, color: textColor),),
                             5.width,
                             Container(
                                 decoration: BoxDecoration(
                                   color: cardColor1,
                                   borderRadius: radius(5),
                                   shape: BoxShape.rectangle,
                                 ),
                                 child: Assets.iconsPhoneCall.iconImage(color:white, size: 14).paddingAll(4)).onTap((){
                               launchUrlString("tel://${model.mobileNo.validate().toString()}");
                             }),
                           ],
                         ),




                     ]).paddingAll(10),

                   ).paddingSymmetric(horizontal: 5,vertical: 5),
                   Column(
                     children: [
                       Card(
                         color: cardColor,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(5),
                         ),
                         margin: EdgeInsets.zero,
                         child: Column(
                           children: [
                             5.height,
                             Text('Diagnosis Images', style: boldTextStyle(color: textColor, size: 14)),
                             10.height,
                             Row(
                               children: [
                                 Container(
                                   width: context.width(),
                                   color: newCardColor2,
                                   padding: EdgeInsets.all(5),
                                   child: Column(
                                     children: [
                                       // Check if d1 is not empty. If not empty, show image and ReUpload button.
                                       d1.isNotEmpty
                                           ? CachedImageWidget(
                                         url: d1,
                                         height: 200,
                                         width: context.width(),
                                         fit: BoxFit.cover,
                                         circle: false,
                                         radius: 5,
                                       ).cornerRadiusWithClipRRect(5).cornerRadiusWithClipRRect(5).onTap((){
                                         _gotoNext(img: d1);
                                       })
                                           : Container(), // Empty Container when no image
                                       5.height,
                                       // Conditional button display
                                       d1.isNotEmpty
                                           ? Container(
                                         width: context.width(),
                                         color: cardColor1,
                                         child: Text('ReUpload', style: boldTextStyle(color: white, size: 12))
                                             .paddingSymmetric(vertical: 5)
                                             .center(),
                                       ).cornerRadiusWithClipRRect(8).onTap(() {
                                         _showBottomSheet(context, page: '1', fileId: uploadFileNumber, pId: model.id.toString());
                                       })
                                           : Container(
                                         width: context.width(),
                                         color: cardColor1,
                                         child: Text('Upload', style: boldTextStyle(color: white, size: 12))
                                             .paddingSymmetric(vertical: 5)
                                             .center(),
                                       ).cornerRadiusWithClipRRect(8).onTap(() {
                                         _showBottomSheet(context, page: '1', fileId: uploadFileNumber, pId: model.id.toString());
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
                                       // Check if d2 is not empty. If not empty, show image and ReUpload button.
                                       d2.isNotEmpty
                                           ? CachedImageWidget(
                                         url: d2,
                                         height: 200,
                                         width: context.width(),
                                         fit: BoxFit.cover,
                                         circle: false,
                                         radius: 5,
                                       ).cornerRadiusWithClipRRect(5).cornerRadiusWithClipRRect(5).onTap((){
                                         _gotoNext(img: d2);
                                       })
                                           : Container(), // Empty Container when no image
                                       5.height,
                                       // Conditional button display
                                       d2.isNotEmpty
                                           ? Container(
                                         width: context.width(),
                                         color: cardColor1,
                                         child: Text('ReUpload', style: boldTextStyle(color: white, size: 12))
                                             .paddingSymmetric(vertical: 5)
                                             .center(),
                                       ).cornerRadiusWithClipRRect(8).onTap(() {
                                         _showBottomSheet(context, page: '2', fileId: uploadFileNumber, pId: model.id.toString());
                                       })
                                           : Container(
                                         width: context.width(),
                                         color: cardColor1,
                                         child: Text('Upload', style: boldTextStyle(color: white, size: 12))
                                             .paddingSymmetric(vertical: 5)
                                             .center(),
                                       ).cornerRadiusWithClipRRect(8).onTap(() {
                                         _showBottomSheet(context, page: '2', fileId: uploadFileNumber, pId: model.id.toString());
                                       }),
                                     ],
                                   ),
                                 ).cornerRadiusWithClipRRect(8).expand(),
                               ],
                             )
                           ],
                         ).paddingAll(5),
                       ).paddingSymmetric(horizontal: 5, vertical: 5),
                       Card(
                         color: cardColor,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(5),
                         ),
                         margin: EdgeInsets.zero,
                         child: Column(
                           children: [
                             5.height,
                             Text('Prescription Images', style: boldTextStyle(color: textColor, size: 12)),
                             10.height,
                             Row(
                               children: [
                                 Container(
                                   width: context.width(),
                                   color: newCardColor2,
                                   padding: EdgeInsets.all(5),
                                   child: Column(
                                     children: [
                                       // Check if p1 is not empty. If not empty, show image and ReUpload button.
                                       p1.isNotEmpty
                                           ? CachedImageWidget(
                                         url: p1,
                                         height: 200,
                                         width: context.width(),
                                         fit: BoxFit.cover,
                                         circle: false,
                                         radius: 5,
                                       ).cornerRadiusWithClipRRect(5).cornerRadiusWithClipRRect(5).onTap((){
                                         _gotoNext(img: p1);
                                       })
                                           : Container(), // Empty Container when no image
                                       5.height,
                                       // Conditional button display
                                       p1.isNotEmpty
                                           ? Container(
                                         width: context.width(),
                                         color: cardColor1,
                                         child: Text('ReUpload', style: boldTextStyle(color: white, size: 12))
                                             .paddingSymmetric(vertical: 5)
                                             .center(),
                                       ).cornerRadiusWithClipRRect(8).onTap(() {
                                         _showBottomSheet(context, page: '3', fileId: uploadFileNumber, pId: model.id.toString());
                                       })
                                           : Container(
                                         width: context.width(),
                                         color: cardColor1,
                                         child: Text('Upload', style: boldTextStyle(color: white, size: 12))
                                             .paddingSymmetric(vertical: 5)
                                             .center(),
                                       ).cornerRadiusWithClipRRect(8).onTap(() {
                                         _showBottomSheet(context, page: '3', fileId: uploadFileNumber, pId: model.id.toString());
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
                                       // Check if p2 is not empty. If not empty, show image and ReUpload button.
                                       p2.isNotEmpty
                                           ? CachedImageWidget(
                                         url: p2,
                                         height: 200,
                                         width: context.width(),
                                         fit: BoxFit.cover,
                                         circle: false,
                                         radius: 5,
                                       ).cornerRadiusWithClipRRect(5).cornerRadiusWithClipRRect(5).onTap((){
                                         _gotoNext(img: p2);
                                       })
                                           : Container(), // Empty Container when no image
                                       5.height,
                                       // Conditional button display
                                       p2.isNotEmpty
                                           ? Container(
                                         width: context.width(),
                                         color: cardColor1,
                                         child: Text('ReUpload', style: boldTextStyle(color: white, size: 12))
                                             .paddingSymmetric(vertical: 5)
                                             .center(),
                                       ).cornerRadiusWithClipRRect(8).onTap(() {
                                         _showBottomSheet(context, page: '4', fileId: uploadFileNumber, pId: model.id.toString());
                                       })
                                           : Container(
                                         width: context.width(),
                                         color: cardColor1,
                                         child: Text('Upload', style: boldTextStyle(color: white, size: 12))
                                             .paddingSymmetric(vertical: 5)
                                             .center(),
                                       ).cornerRadiusWithClipRRect(8).onTap(() {
                                         _showBottomSheet(context, page: '4', fileId: uploadFileNumber, pId: model.id.toString());
                                       }),
                                     ],
                                   ),
                                 ).cornerRadiusWithClipRRect(8).expand(),
                               ],
                             )
                           ],
                         ).paddingAll(5),
                       ).paddingSymmetric(horizontal: 5, vertical: 5),
                     ],
                   ),

                   20.height,
                   if(model.files.validate().length > 1)
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         Text('Old Files', style: boldTextStyle(color: textColor, size: 14),),
                         10.height,
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
                                   5.height,
                                   Text('File Name : ${fileModel.fileNumber.validate().toString()}', style: boldTextStyle(color: textColor, size: 14),).paddingSymmetric(horizontal: 10),
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
                                 ],
                               ),

                             ).paddingSymmetric(horizontal: 5,vertical: 5);
                           },
                         ).paddingAll(5),
                       ],
                     ),

                   20.height,
                   if(model.files!.isNotEmpty)
                     Container(
                       width: context.width(),
                       color: cardColor1,
                       child: Text('New File ?', style: boldTextStyle(color: white, size: 14))
                           .paddingSymmetric(vertical: 8)
                           .center(),
                     ).cornerRadiusWithClipRRect(8).onTap(() {
                       showConfirmDialogCustom(
                         context,
                         width: context.width(),
                         dialogType: DialogType.CONFIRMATION,
                         title: 'Confirmation For New File ?',
                         subTitle: 'Name - ${model.padvi.validate().toString()} ${model.name.validate().toString()} (Age - ${model.age.validate().toString()})\n Samudai - ${model.samudai.validate().toString()}',
                         positiveText: language.lblYes,
                         negativeText: language.lblNo,
                         onAccept: (p0) async {

                           toast((uploadFileNumber.toInt()+1).toString());
                           await Future.delayed(Duration(milliseconds: 300));  // Adjust delay time if necessary

                           _showBottomSheet(context, page: '1', fileId: (uploadFileNumber.toInt()+1).toString(), pId: model.id.toString());

                         },
                       );

                     }).paddingSymmetric(horizontal: 10),

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

  //File? imageFile;
  XFile? pickedFile;

  void _showBottomSheet(BuildContext context,{required String page, required String fileId, required String pId}) {
    showModalBottomSheet<void>(
      backgroundColor: context.cardColor,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SettingItemWidget(
              title: language.lblGallery,
              leading: Icon(Icons.image, color: primaryColor),
              onTap: () {
                _getFromGallery(page: page, fileId: fileId, pId: pId);
                finish(context);
              },
            ),
            Divider(color: context.dividerColor),
            SettingItemWidget(
              title: language.camera,
              leading: Icon(Icons.camera, color: primaryColor),
              onTap: () {
                _getFromCamera(page: page, fileId: fileId, pId: pId);
                finish(context);
              },
            ),
          ],
        ).paddingAll(16.0);
      },
    );
  }

  void _getFromGallery({required String page, required String fileId, required String pId}) async {
    pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
     /* maxWidth: 3000,
      maxHeight: 3000,*/
    );
    if (pickedFile != null) {
      _cropImage(page: page, fileId: fileId, pId: pId,imageFile: File(pickedFile!.path)!);
      //setState(() {});
    }
  }

  _getFromCamera({required String page, required String fileId, required String pId}) async {
    pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      /*maxWidth: 3000,
      maxHeight: 3000,*/
    );
    if (pickedFile != null) {
      _cropImage(page: page, fileId: fileId, pId: pId,imageFile: File(pickedFile!.path)!);
      //setState(() {});
    }
  }


  //CroppedFile? _croppedFile;

  Future<void> _cropImage({required String page, required String fileId, required String pId, required File imageFile}) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
      ],

      uiSettings: [
        AndroidUiSettings(
            showCropGrid: true,
            toolbarTitle: 'Image Crop',
            toolbarColor: cardColor,
            toolbarWidgetColor: textColor,
            activeControlsWidgetColor: primaryColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
      ],
    );
    if (croppedFile != null) {
    //  _croppedFile = croppedFile;
      imageFile = File(croppedFile.path);
      // log('croppedFile'+croppedFile.path.toString());
      uploadImage(page: page, fileId: fileId, pId: pId,imageFile: imageFile);
    }
    }
}
