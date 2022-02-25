import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:flutter/material.dart';

class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FacebookBannerAd(
        placementId: "317652293167747_317652629834380",
        // placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047",
        bannerSize: BannerSize.STANDARD,
        listener: (result, value) {
        },
      ),
    );
  }
}
