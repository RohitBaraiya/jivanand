import 'package:jivanand/utils/colors.dart';
import 'package:jivanand/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

class LoaderWidget extends StatefulWidget {
  const LoaderWidget({super.key});

  @override
  _LoaderWidgetState createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<LoaderWidget> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Container(
      width: context.width(),
      height: context.height(),
      color: loaderBg,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          decoration: boxDecorationWithRoundedCorners(
            borderRadius: BorderRadius.circular(25),
            backgroundColor: cardColor1,
            boxShadow: [
              BoxShadow(
                  color: shadowColorGlobal,
                  offset: const Offset(0, 0),
                  blurRadius: 5,
                  spreadRadius: 2.5),
            ],
          ),
          width: 50,
          height: 50,
          child: const BottomLoader(height: 50, width: 50).cornerRadiusWithClipRRect(45).paddingAll(4),
        ).cornerRadiusWithClipRRect(35),
      ),
    );
  }
}

class BottomLoader extends StatelessWidget {
  final double? height;
  final double? width;

  const BottomLoader({super.key, required this.height,required this.width});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset('assets/lottie/loader_1.json', height: height,width: width, repeat: true,);
  }
}

