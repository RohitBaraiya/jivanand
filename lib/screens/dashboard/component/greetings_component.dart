import 'package:jivanand/main.dart';
import 'package:jivanand/utils/common.dart';
import 'package:jivanand/utils/configs.dart';
import 'package:jivanand/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../generated/assets.dart';
import '../../../utils/colors.dart';


class GreetingsComponent extends StatelessWidget {
  String msg;
  GreetingsComponent({super.key, required this.msg});


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
       // Assets.jivanandJivanandLogo.iconImage2(size: 40).cornerRadiusWithClipRRect(13),
        IconButton(
          onPressed: () {

          },
          icon: Container(
              decoration: BoxDecoration(
                color: cardColor1,
                borderRadius: radius(12),
                shape: BoxShape.rectangle,
              ),
              child: Assets.appIconIcMenu.iconImage(color:white, size: 20).paddingAll(8)),
        ),
        10.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Welcome Jivanand  👋',
              style: boldTextStyle(size: 14,color: textColor),
            ),
            Text(
              APP_NAME_TAG_LINE,
              style: secondaryTextStyle(color: textColor),
            ),
          ],
        ).expand(),
        IconButton(
          onPressed: () {

          },
          icon: Container(
              decoration: BoxDecoration(
                color: cardColor1,
                borderRadius: radius(12),
                shape: BoxShape.rectangle,
              ),
              child: Assets.iconsIcNotification.iconImage(color:white, size: 20).paddingAll(8)),
        ),
      ],
    ).paddingSymmetric(horizontal: 2,vertical: 10);
  }

}
