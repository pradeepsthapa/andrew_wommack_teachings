import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:flutter/material.dart';

class FacebookNativeWidget extends StatelessWidget {
  const FacebookNativeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FacebookNativeAd(
        height: 100,
        placementId: "317652293167747_480488116884163",
        // placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964953543583512",
        adType: NativeAdType.NATIVE_BANNER_AD,
        bannerAdSize: NativeBannerAdSize.HEIGHT_100,
        width: double.infinity,
        backgroundColor: Theme.of(context).primaryColor,
        titleColor: Colors.white,
        descriptionColor: Colors.white,
        buttonColor: Colors.deepPurple,
        buttonTitleColor: Colors.white,
        buttonBorderColor: Colors.white,
        keepExpandedWhileLoading: false,
        listener: (result, value) {
        },
      ),
    );
  }
}
