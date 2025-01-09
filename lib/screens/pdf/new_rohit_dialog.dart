
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jivanand/db/model/CartModel.dart';
import 'package:jivanand/main.dart';
import 'package:flutter/material.dart';
import 'package:jivanand/screens/patients/model/PatientsListModel.dart';
import 'package:jivanand/screens/pdf/model/DownloadedFile.dart';
import 'package:jivanand/utils/colors.dart';
import 'package:jivanand/utils/common.dart';
import 'package:jivanand/utils/constant.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
//import 'package:media_scanner/media_scanner.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;

class NewRohitDialog extends StatefulWidget {
  final List<Images>? list;
  final bool? isPdf;

  const NewRohitDialog({super.key, required this.list, required this.isPdf});

  @override
  State<NewRohitDialog> createState() => _NewRohitDialogState();
}

class _NewRohitDialogState extends State<NewRohitDialog> {
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
                    Text('/'+(widget.list.validate().length).validate().toString(),style: primaryTextStyle(size: 20, color: textColor),),
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
    List<DownloadedFile> temp = [];  // List to hold DownloadedFile objects

    for (int i = 0; i < widget.list.validate().length; i++) {
      step = i + 1;
      String urlFile = widget.list.validate()[i].image.validate().toString();
      downloadProgressNotifier.value = 0;

      // Get the path and category name
      final path = await _localPath();

      // Create the file path
      File file = File('$path/${urlFile.split('/').last}');

      // If the file already exists, add the DownloadedFile object to the temp list
      if (await file.exists()) {
        temp.add(DownloadedFile(
            path: file.path,
            catName: '',
            price: '',
            name: '',
            remark: '',
            buyQty: ''));
        //_scanFile(file.path);
      } else {
        // Download the file if it doesn't exist
        await Dio().download(
          urlFile,
          '${file.path}',
          onReceiveProgress: (actualBytes, int totalBytes) {
            setState(() {
              if (totalBytes != -1) {
                downloadProgressNotifier.value = (actualBytes / totalBytes * 100).floor();
              }
            });
          },
        );
        temp.add(DownloadedFile(
            path: file.path,
            catName: '',
            price: '',
            name: '',
            remark: '',
            buyQty: ''));
        //_scanFile(file.path);
      }

      // Check if all files are downloaded
      if (widget.list.validate().length == step) {
        if (widget.isPdf == false) {
          toast("Downloaded");
        }
        finish(context);
        shareMixed(temp);
      }
    }
  }

 /* static const platform = MethodChannel('veer/refreshGallery');

  Future<void> _scanFile(String filePath) async {
    try {
      await platform.invokeMethod('refreshGallery', {'filePath': filePath});

    } on PlatformException catch (e) {
    }
  }
*/
  Future<void> shareMixed(List<DownloadedFile> listPath) async {
    if(widget.isPdf.validate()){
      String fileName =formatDate(DateTime.now().toString(), format: DATE_FORMAT_FILE_PDF);
      log('filename $fileName');
      createPdfFromUrlsC(listPath,fileName,);
      /*showInDialog(
        context,
        contentPadding: EdgeInsets.zero,
        dialogAnimation: DialogAnimation.SLIDE_TOP_BOTTOM,
        builder: (_) => PdfNameScreen(fileName: fileName,onComplete: (name, isSelected) {
          createPdfFromUrlsC(listPath,name,isSelected);
        },),
        *//*builder: (_) => PdfNameScreen(fileName: fileName,onComplete: (name) {
          createPdfFromUrlsC(listPath,name);
        },),*//*
      );*/
    }else{
      try {
        List<String> temp=[];
        listPath.forEach((element) {
          temp.add(element.path.toString());
        },);
        await Share.shareFiles(temp, text: '');
      } catch (e) {
        print('error: $e');
      }
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
      directory = Directory("/storage/emulated/0/Download/Jivanand");
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final exPath = directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  Future<String> _localPath() async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }








  Future<Uint8List> fetchImageBytes(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception("Failed to load image from URL: $url");
    }
  }

  // Load image from assets (used for header)
  Future<pw.ImageProvider> loadAssetImage(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();
    return pw.MemoryImage(bytes);
  }

  Future<void> createPdfFromUrlsC(List<DownloadedFile> imageUrls, String myFileName) async {
    appStore.setLoading(true);
    final pdf = pw.Document();

    // Load assets (Roboto font and image)
   // final font = pw.Font.ttf(await rootBundle.load('assets/Roboto-Regular.ttf'));
   // final fontBold1 = pw.Font.ttf(await rootBundle.load('assets/Roboto-Bold.ttf'));
    //final fontBold = pw.Font.ttf(await rootBundle.load('assets/Roboto-Black.ttf'));
    //final iconImage = (await rootBundle.load('assets/jito.png')).buffer.asUint8List();
  //  final headerImage = await loadAssetImage('assets/veer/veer_logo.png');

    // Iterate over the list of image file paths (local storage)
    for (var url in imageUrls) {
      try {
        log('Loading image from file path: $url');

        // Load the image from local storage (assuming the path is correct)
        final imageFile = File(url.path); // Assuming URL is a local file path
        if (await imageFile.exists()) {
          final imageBytes = await imageFile.readAsBytes(); // Read the file as bytes

          // Ensure image bytes are not empty
          if (imageBytes.isNotEmpty) {
            // Resize or compress the image using the 'image' package
            final image = img.decodeImage(imageBytes);
            if (image != null) {
              // Resize the image (e.g., scale it to 800x600)
            //  final resizedImage = img.copyResize(image, width: 800);

              // Convert the resized image to a JPEG format with compression
             // final compressedImage = img.encodeJpg(image, quality: 100); // 85% quality

              // Convert bytes to MemoryImage
             // final img1 = pw.MemoryImage(Uint8List.fromList(compressedImage));
              final img1 = pw.MemoryImage(Uint8List.fromList(imageBytes));
              // Add a page with the image to the PDF
              pdf.addPage(pw.Page(pageFormat: PdfPageFormat.a4,
                margin: pw.EdgeInsets.all(10),
                build: (pw.Context context) {
                  return pw.Column(
                    children: [
                      // Header Section: Logo, Category, Product Name, and Price
                      /*pw.Container(
                        width: double.infinity,
                        decoration: pw.BoxDecoration(
                          borderRadius: pw.BorderRadius.all(pw.Radius.circular(0)),
                          color: PdfColor.fromHex('#ECF0F3'),
                        ),
                        child: pw.Row(
                          children: [
                            pw.Container(
                              width: 50,
                              height: 50,
                              decoration: const pw.BoxDecoration(
                                borderRadius: pw.BorderRadius.all(pw.Radius.circular(10)),
                              ),
                              child: pw.Image(headerImage),
                            ),
                            pw.SizedBox(width: 10),
                            pw.Expanded(
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    url.catName.capitalizeEachWord(),
                                    style: pw.TextStyle(
                                      fontSize: 14,
                                      fontWeight: pw.FontWeight.bold,
                                      font: fontBold1,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                  pw.Text(
                                    'DN-${url.name.capitalizeEachWord()}',
                                    style: pw.TextStyle(
                                      fontSize: 12,
                                      fontWeight: pw.FontWeight.normal,
                                      font: fontBold1,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            pw.Text(
                              '₹${url.price.validate().toDouble().toStringAsFixed(0)}/-',
                              style: pw.TextStyle(
                                fontSize: 22,
                                fontWeight: pw.FontWeight.bold,
                                font: fontBold,
                                color: PdfColors.black,
                              ),
                            ),
                            pw.SizedBox(width: 14),
                          ],
                        ),
                      ),*/
                      pw.SizedBox(height: 15),
                      pw.Expanded(child: pw.Image(img1)),
                    ],
                  );
                },
              ));
            } else {
              log('Failed to decode image from $url');
            }
          } else {
            log('Failed to load image from $url: Empty bytes');
          }
        } else {
          log('Image file does not exist at path: $url');
        }
      } catch (e) {
        log('Error loading image from $url: $e');
      }
    }

    // Generate the PDF file
    String fileName = myFileName;
    final outputDir = await getExternalDocumentPathPDF();
    final outputFile = File('$outputDir/$fileName.pdf');

    // Write the generated PDF to the output file
    await outputFile.writeAsBytes(await pdf.save());

    toast('PDF Created');
    print('PDF Created at ${outputFile.path}');
    appStore.setLoading(false);

    // Share the PDF file
    Share.shareFiles([outputFile.path], text: 'Check out my PDF!');
  }


  static Future<String> getExternalDocumentPathPDF() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      directory = Directory("/storage/emulated/0/Download/Jivanand/PDF");
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final exPath = directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

}
