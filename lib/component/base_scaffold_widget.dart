import 'package:jivanand/component/back_widget.dart';
import 'package:jivanand/component/base_scaffold_body.dart';
import 'package:jivanand/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/constant.dart';

class AppScaffold extends StatelessWidget {
  final String? appBarTitle;
  final List<Widget>? actions;

  final Widget child;
  final Color? scaffoldBackgroundColor;
  final Widget? bottomNavigationBar;
  final bool showLoader;

  const AppScaffold({super.key,
    this.appBarTitle,
    required this.child,
    this.actions,
    this.scaffoldBackgroundColor,
    this.bottomNavigationBar,
    this.showLoader = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarTitle != null
            ? AppBar(
          title: Text(appBarTitle.validate(), style: boldTextStyle(color: textColor, size: APP_BAR_TEXT_SIZE)),
          elevation: 0.0,
          backgroundColor: cardColor,
          leading: context.canPop ?  const BackWidget() : null,
          actions: actions,
        )
            : null,
        backgroundColor: scaffoldBackgroundColor,
        body: Body(showLoader: showLoader, child: child),
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}