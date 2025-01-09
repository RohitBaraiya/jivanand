import 'package:jivanand/component/back_widget.dart';
import 'package:jivanand/component/loader_widget.dart';
import 'package:jivanand/main.dart';
import 'package:jivanand/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ZoomImageScreen extends StatefulWidget {
  final int index;
  final List<String>? galleryImages;

  const ZoomImageScreen({super.key, required this.index, this.galleryImages});

  @override
  _ZoomImageScreenState createState() => _ZoomImageScreenState();
}

class _ZoomImageScreenState extends State<ZoomImageScreen> {
  bool showAppBar = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusColor();
    enterFullScreen();

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exitFullScreen();

        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: showAppBar
            ? appBarWidget(
                language.lblGallery,
                textColor: textColor,
                color: cardColor,
                backWidget:  const BackWidget(),
              )
            : null,
        body: GestureDetector(
          onTap: () {
            showAppBar = !showAppBar;

            if (showAppBar) {
              exitFullScreen();
            } else {
              enterFullScreen();
            }
            setStatusColor();

            setState(() {});
          },
          child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            enableRotation: false,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            pageController: PageController(initialPage: widget.index),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: Image.network(widget.galleryImages![index], errorBuilder: (context, error, stackTrace) => PlaceHolderWidget()).image,
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained,
                errorBuilder: (context, error, stackTrace) => PlaceHolderWidget(),
                heroAttributes: PhotoViewHeroAttributes(
                  tag: widget.galleryImages![index],
                ),
              );
            },
            itemCount: widget.galleryImages!.length,
            loadingBuilder: (context, event) => const LoaderWidget(),
          ),
        ),
      ),
    );
  }
}
