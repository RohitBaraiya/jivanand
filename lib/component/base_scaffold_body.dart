import 'package:jivanand/component/loader_widget.dart';
import 'package:jivanand/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class Body extends StatelessWidget {
  final Widget child;
  final bool showLoader;

  const Body({super.key, required this.child, this.showLoader = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      height: context.height(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          if (showLoader) Observer(builder: (_) => const LoaderWidget().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
