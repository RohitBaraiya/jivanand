import 'package:jivanand/component/shimmer_widget.dart';
import 'package:jivanand/main.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class WalletHistoryShimmer extends StatelessWidget {
  const WalletHistoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      itemCount: 20,
      listAnimationType: ListAnimationType.None,
      itemBuilder: (BuildContext context, index) {
        return Container(
          width: context.width(),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: boxDecorationWithRoundedCorners(
            borderRadius: radius(),
            backgroundColor: context.cardColor,
            border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget(
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
                ),
              ),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  4.height,
                  ShimmerWidget(height: 15, width: context.width()),
                  4.height,
                  ShimmerWidget(height: 15, width: context.width()),
                  4.height,
                  ShimmerWidget(height: 15, width: context.width()),
                ],
              ).expand(),
            ],
          ),
        );
      },
    );
  }
}
