
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jivanand/utils/colors.dart';
import 'package:jivanand/utils/common.dart';
import 'package:jivanand/utils/constant.dart';
//import 'package:media_scanner/media_scanner.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';




class RohitDialog extends StatefulWidget {

  final String myModel;
  final String catName;

  const RohitDialog({super.key, required this.myModel, required this.catName});

  @override
  State<RohitDialog> createState() => _RohitDialogState();
}

class _RohitDialogState extends State<RohitDialog> {
  @override
  void initState() {
    super.initState();
    init();
  }

  ValueNotifier downloadProgressNotifier = ValueNotifier(0);

  int step=1;
  CircularSliderAppearance? appearance02;
  void init() async {
    final customWidth02 = CustomSliderWidths(trackWidth: 5, progressBarWidth: 10, shadowWidth: 13);
    final customColors02 = CustomSliderColors(
        dotColor: Colors.white.withOpacity(0.8),
        trackColor: progressTrackColor.withOpacity(0.3),
        progressBarColor: progressBarColor,
        shadowColor: progressShdowColor,
        shadowStep: 12.0,
        shadowMaxOpacity: 0.15);
    appearance02 = CircularSliderAppearance(
        customWidths: customWidth02,
        customColors: customColors02,
        startAngle: 270,
        angleRange: 360,
        size: 100.0,
        spinnerDuration: 1000,
        animDurationMultiplier: 5.0,
        animationEnabled: false);
    downloadFileFromServer();
  }



  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: radius(),
          color: cardColor
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SleekCircularSlider(
            min: 0,
            max: 100,
            appearance: appearance02!,
            initialValue: downloadProgressNotifier.value.toString().toDouble(),

            innerWidget: (double value) => Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text((step).validate().toString(),style: boldTextStyle(size: 30,color: textColor),),
                    Text('/1',style: primaryTextStyle(size: 20, color: textColor),),
                  ],
                ).center()
            ),
          ).center(),
          10.height,
          Text('Please wait...',style: boldTextStyle(size: 14,color: textColor),).center(),
          Text('We are Downloading.',style: boldTextStyle(size: 14,color: textColor,)).center(),
        ],
      ),
    );
  }

  downloadFileFromServer() async {

      String data = widget.myModel;

      downloadProgressNotifier.value = 0;
      String fileName = formatDate(DateTime.now().toString(), format: DATE_FORMAT_FILE);
      final path = await _localPath;
      //File file = File('$path/${'${fileName}_.jpg'}');

      File file = File('$path/${widget.myModel.validate().toString().split('/').last}');

      if(await file.exists()){
        shareMixed(file.path);
        finish(context);
      }else{
        await Dio().download(
            options: Options(
              headers: {"Connection": "Keep-Alive"},
            ),
            data,
            file.path,
            onReceiveProgress: (actualBytes, int totalBytes) {
              setState(() {
                if (totalBytes != -1) {
                  // log('aaaa${(actualBytes / totalBytes * 100).floor()}');
                  downloadProgressNotifier.value = (actualBytes / totalBytes * 100).floor();
                }
              });
            });
        print('File downloaded at ${file.path}');
        //MediaScanner.loadMedia(path: "${file.path}");
        toast("Downloaded");

        shareMixed(file.path);
        finish(context);
      }
  }

  Future<void> shareMixed(String path) async {
    try {
      List<String> temp=[];
      temp.add(path.toString());
      await Share.shareFiles(temp, text: '');
    } catch (e) {
      print('error: $e');
    }
  }

  Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      directory = Directory("/storage/emulated/0/Download/VeerCreation/${widget.catName}");
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final exPath = directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }



  downloadVideoThumbnail({required String fileName,required String url}) async {
    final path = await _localPath1;
    File file = File('$path/$fileName');
    // var url = data.url.validate().toString();
    await Dio().download(
      url,
      file.path,);
  }

  static Future<String> getExternalDocumentPath1() async {
    Directory directory =await getApplicationDocumentsDirectory() ;
    final exPath = '${directory.path}/Video_Thumbnail';
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath1 async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath1();
    return directory;
  }



}
