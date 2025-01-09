import 'dart:async';

import 'package:jivanand/component/cached_image_widget.dart';
import 'package:jivanand/utils/configs.dart';
import 'package:jivanand/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SliderLocationComponent extends StatefulWidget {
  final List<String> sliderList;
  final VoidCallback? callback;

  const SliderLocationComponent({super.key, required this.sliderList, this.callback, });

  @override
  State<SliderLocationComponent> createState() => _SliderLocationComponentState();
}

class _SliderLocationComponentState extends State<SliderLocationComponent> {
  PageController sliderPageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (getBoolAsync(AUTO_SLIDER_STATUS, defaultValue: true) && widget.sliderList.length >= 2) {
      _timer = Timer.periodic(const Duration(seconds: DASHBOARD_AUTO_SLIDER_SECOND), (Timer timer) {
        if (_currentPage < widget.sliderList.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        sliderPageController.animateToPage(_currentPage, duration: const Duration(milliseconds: 950), curve: Curves.easeOutQuart);
      });

      sliderPageController.addListener(() {
        _currentPage = sliderPageController.page!.toInt();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    sliderPageController.dispose();
  }

  Widget getSliderWidget() {
    return SizedBox(
      height: 180,
      width: context.width(),
      child: Stack(
        children: [
          widget.sliderList.isNotEmpty
              ? PageView(
                  controller: sliderPageController,
                  children: List.generate(
                    widget.sliderList.length,
                    (index) {
                      String data = widget.sliderList[index];
                      return CachedImageWidget(url: data.validate(), height: 250, width: context.width(), fit: BoxFit.cover).onTap(() {
                        /*if (data.type == SERVICE) {
                          ServiceDetailScreen(serviceId: data.typeId.validate().toInt()).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                        }*/
                      });
                    },
                  ),
                )
              : CachedImageWidget(url: '', height: 250, width: context.width()),
          if (widget.sliderList.length.validate() > 1)
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: DotIndicator(
                pageController: sliderPageController,
                pages: widget.sliderList,
                indicatorColor: white,
                unselectedIndicatorColor: white,
                currentBoxShape: BoxShape.rectangle,
                boxShape: BoxShape.rectangle,
                currentBorderRadius: radius(10),
                borderRadius: radius(10),
                currentDotSize: 20,
                currentDotWidth: 5,
                dotSize: 5,
              ),
            ),
        ],
      ),
    );
  }

  Decoration get commonDecoration {
    return boxDecorationDefault(
      color: context.cardColor,
      boxShadow: [
        BoxShadow(color: shadowColorGlobal, offset: const Offset(1, 0)),
        BoxShadow(color: shadowColorGlobal, offset: const Offset(0, 1)),
        BoxShadow(color: shadowColorGlobal, offset: const Offset(-1, 0)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return getSliderWidget();
  }
}
