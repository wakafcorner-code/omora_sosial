import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:untitled/common/managers/session_manager.dart';

class BannerAdView extends StatefulWidget {
  final bool top;
  final bool bottom;

  BannerAdView({super.key, this.top = false, this.bottom = false});

  @override
  State<BannerAdView> createState() => _BannerAdViewState();
}

class _BannerAdViewState extends State<BannerAdView> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAd();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd != null) {
      return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE2E8F0), width: 0.8),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 2),
        alignment: Alignment.center,
        child: SafeArea(
          bottom: widget.bottom,
          top: widget.top,
          child: SizedBox(
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  void loadAd() {
    if (SessionManager.shared.isAdMobOn()) {
      final String adUnitId = SessionManager.shared.getBannerAdId();
      if (adUnitId.isEmpty) return;

      _bannerAd = BannerAd(
        adUnitId: adUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            setState(() {});
          },
          onAdFailedToLoad: (ad, err) {
            debugPrint('BannerAd failed to load: $err');
            ad.dispose();
            _bannerAd = null;
            setState(() {});
          },
        ),
      )..load();
    }
  }
}
