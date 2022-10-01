import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdManager {

  Future<void> loadShowAd() async{
    await AppOpenAd.load(
      adUnitId: 'ca-app-pub-2693320098955235/7895565336',
      // adUnitId: 'ca-app-pub-3940256099942544/3419835294',
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) => ad.show(),
        onAdFailedToLoad: (error) {
          // Handle the error.
        },
    )
    );
  }
}