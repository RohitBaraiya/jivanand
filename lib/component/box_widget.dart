import 'package:flutter/material.dart';
import 'package:jivanand/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';


class BoxWidget extends StatelessWidget {
  final Widget child;
  double radius;

  BoxWidget({super.key, required this.child, this.radius = 8});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
     // padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      //  border: Border.all(color: textColor.withOpacity(0.30), width: 0.5),
        boxShadow: [
          BoxShadow(
            color : textColor.withOpacity(0.20),
            offset: const Offset(0, 0),
            blurRadius: 1,
            spreadRadius: 0.5,//-10
          ),
        ],
        color: cardColor,
      ),
      child: child,
    );
  }
}
