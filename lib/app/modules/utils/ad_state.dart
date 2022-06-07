import 'package:efeitos_sonoros_vai_dar_namoro/app/shared/consts.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;

  AdState(this.initialization);

  String get bannerAdUnitId => bannerUnitId;

  static final BannerAdListener adListener = BannerAdListener(
    onAdLoaded: (ad) => print('Ad loaded'),
    onAdFailedToLoad: (ad, error) => Get.snackbar('Erro',
        'Erro ao carregar o anúncio.'), //print('Ad failed to load: $error'),
    onAdOpened: (ad) => print('Ad opened'),
    onAdClosed: (ad) => print('Ad closed'),
    onAdClicked: (ad) => print('Ad clicked'),
    onAdImpression: (ad) => print('Ad impression'),
  );

  static final InterstitialAdLoadCallback interstitialAdLoadCallback =
      InterstitialAdLoadCallback(
    onAdLoaded: (InterstitialAd ad) {
      print('Ad interstitial loaded');
    },
    onAdFailedToLoad: (error) {
      Get.snackbar('Erro', 'Erro ao carregar o anúncio');
      //print('Ad interstitial failed to load: $error');
    },
  );
}
