import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:untitled/common/managers/logger.dart';
import 'package:untitled/common/managers/session_manager.dart';

class InterstitialManager {
  static var shared = InterstitialManager();

  InterstitialAd? interstitialAd;
  bool isAdLoading = false;
  DateTime? lastAdShownTime;

  // Kebijakan Google AdMob: Batas interval minimal antar Iklan Interstitial (50 detik)
  static const int minAdIntervalSeconds = 50;

  InterstitialManager() {
    if (SessionManager.shared.isAdMobOn()) {
      loadAd();
    }
  }

  void loadAd() {
    if (!SessionManager.shared.isAdMobOn()) return;
    if (isAdLoading || interstitialAd != null) return;

    String adUnitId = SessionManager.shared.getInterstitialAdId();
    if (adUnitId.isEmpty) return;

    isAdLoading = true;

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          isAdLoading = false;
          interstitialAd = ad;
          Loggers.success('InterstitialAd successfully loaded.');

          interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              lastAdShownTime = DateTime.now();
              Loggers.info('InterstitialAd showed full screen content.');
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              Loggers.error('InterstitialAd failed to show: $err');
              ad.dispose();
              interstitialAd = null;
              loadAd();
            },
            onAdDismissedFullScreenContent: (ad) {
              Loggers.info('InterstitialAd dismissed.');
              ad.dispose();
              interstitialAd = null;
              loadAd();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          isAdLoading = false;
          interstitialAd = null;
          Loggers.error('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void showAd() {
    if (!SessionManager.shared.isAdMobOn()) return;

    // Kebijakan Google AdMob: Cek Frequency Capping agar tidak mengganggu pengguna
    if (lastAdShownTime != null) {
      final difference = DateTime.now().difference(lastAdShownTime!).inSeconds;
      if (difference < minAdIntervalSeconds) {
        Loggers.info('InterstitialAd skipped due to AdMob frequency capping ($difference / $minAdIntervalSeconds sec).');
        return;
      }
    }

    if (interstitialAd != null) {
      interstitialAd!.show();
      interstitialAd = null;
    } else {
      loadAd();
    }
  }
}
