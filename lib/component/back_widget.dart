import 'package:jivanand/utils/common.dart';
import 'package:jivanand/utils/images.dart';
import 'package:jivanand/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BackWidget extends StatelessWidget {
  final Function()? onPressed;
  final Color? iconColor;

  const BackWidget({super.key, this.onPressed, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ??
          () {
            finish(context);
          },
      icon: ic_arrow_left.iconImage(color: textColor),
    );
  }
}
